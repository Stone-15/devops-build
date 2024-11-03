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
FROM node:18  

# Install serve globally  
RUN npm install -g serve  

# Set the working directory to the build directory  
WORKDIR /app/build  

# Copy the built files from the builder stage  
COPY --from=builder /app/build .  

# Expose port 80  
EXPOSE 80  

# Command to run the app  
CMD ["serve", "-s", ".", "-l", "80"]