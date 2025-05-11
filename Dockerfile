# Use the official Bun image for the build stage
FROM oven/bun:1 AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package.json ./
COPY bun.lockb ./ 2>/dev/null || :
RUN bun install --frozen-lockfile

# Copy source code and build the application
COPY . .
RUN bun run build

# Production stage with Nginx to serve static files
FROM nginx:alpine AS production

# Create default nginx configuration if it doesn't exist in the build
RUN echo 'server { \
    listen 80; \
    root /usr/share/nginx/html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# Try to copy nginx.conf if it exists, but don't fail if it doesn't
COPY --from=build /app/nginx.conf /etc/nginx/conf.d/default.conf 2>/dev/null || true

# Copy built static files from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]