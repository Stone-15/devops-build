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

# Stage 2: Serve the application using nginx  
FROM nginx:alpine  # Use nginx image to serve the files  

# Copy the built files from the builder stage to the nginx html directory  
COPY --from=builder /app/build /usr/share/nginx/html  

# Expose port 80 for serving  
EXPOSE 80  

# Use the default CMD provided by nginx