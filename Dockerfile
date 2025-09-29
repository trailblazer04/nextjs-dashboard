# ===== Build Stage =====
FROM node:20 AS builder

# Set working directory
WORKDIR /app

# Copy dependency files first (for caching)
COPY package*.json pnpm-lock.yaml ./

# Install pnpm & dependencies
RUN npm install -g pnpm
# RUN pnpm install --frozen-lockfile
RUN pnpm install

# Copy all files
COPY . .

# Skip DB access during build
# ENV SKIP_DB=true

# Build Next.js app
RUN pnpm build

# ===== Production Stage =====
# FROM node:20 AS prod

# WORKDIR /app

# # Copy only necessary files from builder
# # COPY --from=builder /app/package*.json ./
# # COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/.next/standalone ./
# COPY --from=builder /app/.next/static ./.next/static
# COPY --from=builder /app/public ./public

# Expose port
EXPOSE 4000

# Use real DB connection at runtime
# ENV NODE_ENV=production

# Start app
# CMD ["node", "server.js"]
CMD ["pnpm", "start"]