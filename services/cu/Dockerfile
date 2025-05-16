FROM node:alpine AS builder
ARG CU_VERSION=main

RUN apk add git

WORKDIR /download
RUN git clone --branch=${CU_VERSION} --depth=1 https://github.com/permaweb/ao.git

FROM node:22-alpine AS runner
COPY --from=builder /download/ao/servers/cu /usr/app
WORKDIR /usr/app

RUN npm install --ignore-engines --omit=dev

EXPOSE 80
CMD ["npm", "start"]
