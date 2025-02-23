FROM node:alpine AS runner
WORKDIR /app
COPY package.json .
COPY server.mjs .

RUN npm install

EXPOSE 80
CMD ["node", "server.mjs"]
