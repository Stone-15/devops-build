# Use a base image (e.g., Node.js or Python)  
FROM node:14  

# Set the working directory  
WORKDIR /app  

# Copy package files & install dependencies  
COPY package*.json ./  
RUN npm install  

# Copy the rest of the application  
COPY . .  

# Expose the application port  
EXPOSE 80  

# Command to run the application  
CMD ["npm", "start"]