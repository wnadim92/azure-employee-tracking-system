# Stage 1: Build the React application
FROM node:22.12.0-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy dependency files first to leverage Docker caching
# Note: Path is relative to the Dockerfile (my-app/...)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Accept the build argument and set it as an environment variable
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL

# Build the production-ready application
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM nginx:1.27.3-alpine

# Remove default Nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output from the 'build' stage to Nginx's public folder
# Note: 'create-react-app' typically outputs to 'build', while Vite uses 'dist'
COPY --from=build /app/build /usr/share/nginx/html

# Copy a custom Nginx config if needed (optional, see below)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
