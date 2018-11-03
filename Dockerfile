FROM cryptopath/alpine:3.8

# set version, revision and build-date labels
ARG VERSION="dev"
ARG REVISION="HEAD"
ARG BUILD_DATE="unknown"

# metadata as defined in Open Container Initiative (OCI) annotations specs
# -> https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.title="cryptopath/offlineimap" \
      org.opencontainers.image.description="Nicely configurable OfflineIMAP and Cron based on an Alpine docker image" \
      org.opencontainers.image.vendor="Cryptopath" \
      org.opencontainers.image.authors="CeRiAl <ikhatib@gmail.com>" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://hub.docker.com/r/cryptopath/offlineimap/" \
      org.opencontainers.image.documentation="https://github.com/CeRiAl/docker-offlineimap#readme" \
      org.opencontainers.image.source="https://github.com/CeRiAl/docker-offlineimap" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${REVISION}" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.ref.name="cryptopath-offlineimap-${VERSION}"

RUN \
  echo "**** install packages ****" && \
    apk add --no-cache \
      offlineimap

# copy local files
COPY root/ /

# environment
ENV CONFIG_PATH="/vol/config" \
    SECRETS_PATH="/vol/secrets" \
    MAIL_PATH="/vol/mail" \
    CRON_SCHEDULE="0 3 * * *"

# volumes
VOLUME /vol
