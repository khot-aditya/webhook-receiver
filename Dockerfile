# Use a lightweight Node.js 18 image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy the rest of the application code
COPY . .

# Expose the port on which the Node.js server runs
EXPOSE 5002

# Ensure there is no entrypoint issue by explicitly starting the app
CMD ["node", "index.js"]
