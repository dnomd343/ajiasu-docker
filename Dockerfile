ARG ALPINE="alpine:3.22"

FROM --platform=${BUILDPLATFORM} ${ALPINE} AS ajiasu
ENV AJIASU="4.2.3.0"
WORKDIR /download/
ARG TARGETARCH
RUN case "${TARGETARCH}" in     \
      "386") ARCH="x86";;       \
      "arm") ARCH="armel";;     \
      "amd64") ARCH="amd64";;   \
      "arm64") ARCH="aarch64";; \
      *) exit 1;;               \
    esac && \
    wget "https://www.91ajs.com/files/downloads/linux/ajiasu-${ARCH}-${AJIASU}.tar.gz" -O- | tar xz

FROM ${ALPINE}
COPY --from=ajiasu /download/ajiasu /usr/bin/
ENTRYPOINT ["ajiasu"]
