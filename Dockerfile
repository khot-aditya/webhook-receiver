# Use the official Node.js 18 Alpine image as a parent image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies (using --production for only production dependencies)
RUN npm install --production

# Copy the rest of the application code to the working directory
COPY . .

# Expose the port your app will run on
EXPOSE 5002

# Set the environment path so the deploy command is accessible
ENV PATH="/bin:/usr/local/bin:${PATH}"

# Start the Node.js application
CMD ["node", "index.js"]
