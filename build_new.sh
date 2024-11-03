#!/bin/bash  
# build.sh  

# List all files in the current directory for debugging  
echo "Current directory contents:"  
ls -la  

# Run docker-compose build  
docker-compose build  

# Run docker-compose up to start the services  
docker-compose up -d