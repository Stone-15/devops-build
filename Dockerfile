# Stage 1: Build the React application  
FROM node:18 AS builder  

# Set the working directory  
WORKDIR /app  

# Copy package.json and package-lock.json  
COPY package*.json ./  

# Install app dependencies (including dev dependencies)  
RUN npm ci  

# Copy the rest of your application code  
COPY . .  

# Build the React application  
RUN npm run build  

# Stage 2: Serve the application  
FROM serve:latest  # Use the official serve image  

# Set the working directory to /usr/share/nginx/html (default for serve)  
WORKDIR /usr/share/nginx/html  

# Copy the built files from the builder stage  
COPY --from=builder /app/build .  

# Expose port 80 (default port for serving)  
EXPOSE 80  

# Use the default CMD provided by the serve image