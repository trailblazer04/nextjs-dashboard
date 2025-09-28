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

FROM node:latest AS build

WORKDIR /app

COPY package*.json pnpm-lock.yaml ./

RUN npm install -g pnpm
RUN pnpm install

COPY . .

RUN pnpm build

FROM node:alpine AS prod 

WORKDIR /app

COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static
COPY --from=build /app/public ./public

EXPOSE 3000

CMD [ "node", "server.js" ]