################################################################################
# Download

FROM node:alpine AS downloader
WORKDIR /download

RUN apk add git

ARG REPO
ARG BRANCH
RUN git clone --branch=${BRANCH} --depth=1 ${REPO} .

################################################################################
# Build

FROM node:alpine AS builder
WORKDIR /build
COPY --from=downloader /download .

RUN apk add git

# `install` runs `prepare` which runs `build`
RUN yarn install

################################################################################
# Run

FROM node:alpine AS runner
WORKDIR /app
COPY --from=builder /build/bin bin
COPY --from=builder /build/node_modules node_modules

ENTRYPOINT ["node", "bin/index.js"]
