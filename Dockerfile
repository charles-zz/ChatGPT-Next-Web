FROM node:18-alpine AS base
FROM base AS builder
FROM base AS deps

#RUN apk add --no-cache libc6-compat
#RUN npm cache clean --force
WORKDIR /app
#COPY --from=deps /app/node_modules ./node_modules
COPY . .

#RUN yarn config set registry 'https://registry.npmmirror.com/'
RUN yarn config set registry 'http://mirrors.cloud.tencent.com/npm'
RUN yarn install

EXPOSE 3000
# 构建应用
RUN yarn build

# 启动应用
CMD ["npm", "start"]
