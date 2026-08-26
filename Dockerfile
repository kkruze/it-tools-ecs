# Stage 1: Build the application

FROM node:18.18.2-alpine AS builder

WORKDIR /app

RUN npm install -g pnpm@9.11.0

COPY app/package.json app/pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

COPY /app ./

RUN pnpm build

# Stage 2: Application Runtime

FROM nginxinc/nginx-unprivileged:alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html/

EXPOSE 8080
