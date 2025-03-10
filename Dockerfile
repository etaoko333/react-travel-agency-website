# Use an official Node.js runtime as the base image
FROM node:18 as build

# Set the working directory
WORKDIR /app

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Remove existing yarn binary if it exists, then install yarn globally with --force
RUN rm -f /usr/local/bin/yarn && npm install -g yarn --force

# Install dependencies
RUN yarn install

# Copy the rest of the application code
COPY . .

# Build the application
RUN yarn build

# Use a lightweight web server to serve the built files
FROM nginx:alpine

# Copy the built files from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
