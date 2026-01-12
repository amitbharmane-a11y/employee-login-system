# Multi-stage Docker build for Employee Login System

# Stage 1: Build the frontend
FROM node:18-alpine AS frontend-build

WORKDIR /app/client

# Copy package files
COPY client/package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY client/ ./

# Build the application
RUN npm run build

# Stage 2: Setup the backend
FROM node:18-alpine AS backend-setup

WORKDIR /app/server

# Copy package files
COPY server/package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY server/ ./

# Stage 3: Production image
FROM node:18-alpine AS production

# Install serve for static file serving
RUN npm install -g serve

# Create app directory
WORKDIR /app

# Copy built frontend from frontend-build stage
COPY --from=frontend-build /app/client/build ./client/build

# Copy backend from backend-setup stage
COPY --from=backend-setup /app/server ./server

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Change ownership
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expose ports
EXPOSE 5000 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Start both frontend and backend
CMD serve -s client/build -l 3000 & cd server && npm start