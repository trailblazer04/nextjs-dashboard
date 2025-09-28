# # Use Node LTS
# FROM node:latest

# # Set working directory 
# WORKDIR /app

# # Copy package files and install dependencies
# COPY package*.json pnpm-lock.yaml ./

# # install pnpm
# RUN npm install -g pnpm
# # RUN pnpm ci (The pnpm ci command does not exist in pnpm as a direct equivalent to npm ci. Instead, pnpm's equivalent behavior for continuous integration (CI) environments is achieved by using pnpm install with the --frozen-lockfile option.)
# RUN pnpm install --frozen-lockfile

# # Copy the rest of the project
# COPY . .

# # Build Next.js app
# RUN pnpm run build 

# # Expose the default Next.js port
# EXPOSE 4000

# # Start the app
# CMD [ "node", "server.js" ]

# FROM node:latest AS build

# WORKDIR /app

# COPY package*.json pnpm-lock.yaml ./

# RUN npm install -g pnpm
# RUN pnpm install

# COPY . .

# RUN pnpm build

# FROM node:alpine AS prod 

# WORKDIR /app

# COPY --from=build /app/.next/standalone ./
# COPY --from=build /app/.next/static ./.next/static
# COPY --from=build /app/public ./public

# EXPOSE 4000

# CMD [ "node", "server.js" ]

# ===== Build Stage =====
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy dependency files first (for caching)
COPY package*.json pnpm-lock.yaml ./

# Install pnpm & dependencies
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile

# Copy all files
COPY . .

# Skip DB access during build
ENV SKIP_DB=true

# Build Next.js app
RUN pnpm build

# ===== Production Stage =====
FROM node:20-alpine AS prod

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

# Expose port
EXPOSE 4000

# Use real DB connection at runtime
ENV NODE_ENV=production

# Start app
CMD ["node", "server.js"]