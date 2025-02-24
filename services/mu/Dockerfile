################################################################################
# Download

FROM alpine:latest AS downloader
WORKDIR /download

RUN apk add git

ARG MU_VERSION=main
RUN git clone --branch=${MU_VERSION} --depth=1 https://github.com/permaweb/ao.git

################################################################################
# Build

FROM node:22 AS builder
WORKDIR /build
COPY --from=downloader /download/ao/servers/mu .

RUN npm install --ignore-engines --omit=dev

################################################################################
# Run

FROM node:22 AS runner
WORKDIR /app
COPY --from=builder /build/node_modules node_modules
COPY --from=builder /build/package.json .
COPY --from=builder /build/src src

EXPOSE 80
CMD ["npm", "start"]
