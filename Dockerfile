
FROM node:16.16.0 
WORKDIR /app 
COPY ["package.json", "package-lock.json*", "./"]
RUN \
    npm install && \
    export mongoURI=$(echo "${mongoURI}")
COPY . . 
CMD ["npm", "start"]
ENV mongoURI $mongoURI