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

RUN yarn install
ARG ARWEAVE_GATEWAY_URL
ENV VITE_ARWEAVE_GATEWAY_URL=${ARWEAVE_GATEWAY_URL}
RUN yarn run build --mode development

################################################################################
# Run

FROM httpd:alpine AS runner
COPY --from=builder /build/dist /usr/local/apache2/htdocs
