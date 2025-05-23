# Use the official Bun image for the build stage
FROM oven/bun:1 AS build

WORKDIR /app

# Copy source code including package files
COPY . .

# Install dependencies and build
RUN bun install
RUN bun run build

# Production stage with Nginx to serve static files
FROM nginx:alpine AS production

# Create default nginx configuration
RUN echo 'server { \
    listen 80; \
    root /usr/share/nginx/html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# Copy built static files from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]