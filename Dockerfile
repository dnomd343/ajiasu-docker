ARG ALPINE="alpine:3.22"

FROM --platform=${BUILDPLATFORM} ${ALPINE} AS ajiasu
RUN wget -O- https://www.91ajs.com/download | grep -oEm1 '(\d[0-9.]+\d).tar.gz' > VERSION
ARG TARGETARCH
RUN case "${TARGETARCH}" in     \
      "386") ARCH="x86";;       \
      "arm") ARCH="armel";;     \
      "amd64") ARCH="amd64";;   \
      "arm64") ARCH="aarch64";; \
      *) exit 1;;               \
    esac && echo "${ARCH}" > ARCH
RUN wget "https://www.91ajs.com/files/downloads/linux/ajiasu-$(cat ARCH)-$(cat VERSION)" -O- | tar xz
RUN mv ajiasu /tmp/

FROM ${ALPINE}
COPY --from=ajiasu /tmp/ajiasu /usr/bin/
ENTRYPOINT ["ajiasu"]
