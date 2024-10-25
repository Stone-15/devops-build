FROM node:14  

WORKDIR /app  

# Copy package.json files  
COPY package*.json ./  

RUN npm install  

# Copy the rest of the application files  
COPY . .  

EXPOSE 8080  

CMD ["node", "app.js"]  # Replace "app.js" with the entry point of your app