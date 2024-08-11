FROM node:18-alpine AS base
FROM base AS deps

RUN apk add --no-cache libc6-compat

WORKDIR /app
#COPY --from=deps /app/node_modules ./node_modules
COPY . .

#RUN yarn config set registry 'https://registry.npmmirror.com/'
RUN yarn config set registry 'http://mirrors.cloud.tencent.com/npm'
RUN yarn install
#step 2
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# 构建应用
RUN yarn build

# step 3
FROM base AS runner


WORKDIR /app
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/.next/server ./.next/server

EXPOSE 3000


# 启动应用
CMD ["npm", "start"]
