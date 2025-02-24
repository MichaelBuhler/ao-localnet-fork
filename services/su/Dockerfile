################################################################################
# Download

FROM node:alpine AS downloader
WORKDIR /download

RUN apk add git

ARG SU_VERSION=main
RUN git clone --branch=${SU_VERSION} --depth=1 https://github.com/permaweb/ao.git

################################################################################
# Run

FROM rust:latest AS runner
WORKDIR /app
COPY --from=downloader /download/ao/servers/su/su .

RUN chmod +x su

EXPOSE 80
CMD ["./su", "su", "80"]
