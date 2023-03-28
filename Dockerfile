ARG ALPINE="alpine:3.17"

FROM ${ALPINE} AS ajiasu
RUN wget -O- https://www.91ajs.com/download | grep -oEm1 '(\d[0-9.]+\d).tar.gz' > VERSION
RUN case "$(uname -m)" in \
      'i386' | 'i686') ARCH="x86";; \
      'amd64' | 'x86_64') ARCH="x86_64";; \
      'armv7' | 'armv7l' | 'armv8' | 'aarch64') ARCH="armel";; \
      *) echo "Architecture not supported" && exit 1;; \
    esac && echo "${ARCH}" > ARCH
RUN wget "https://www.91ajs.com/files/downloads/linux/ajiasu-$(cat ARCH)-$(cat VERSION)" -O- | tar xz
RUN mv ajiasu /tmp/

FROM ${ALPINE}
COPY --from=ajiasu /tmp/ajiasu /usr/bin/
ENTRYPOINT ["ajiasu"]
