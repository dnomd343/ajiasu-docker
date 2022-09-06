ARG ALPINE_IMG="alpine:3.16"

FROM ${ALPINE_IMG} AS asset
RUN url="https://www.91ajs.com/files/downloads/linux" && \
    version=$(wget -qO - https://www.91ajs.com/download | grep '.tar.gz' | grep -oEm 1 '[0-9.]{3,}[0-9]') && \
    case "$(uname -m)" in \
      'i386' | 'i686') arch="ajiasu-x86";; \
      'amd64' | 'x86_64') arch="ajiasu-x86_64";; \
      'armv7' | 'armv7l') arch="ajiasu-armel";; \
      'armv8' | 'aarch64') arch="ajiasu-armel";; \
      *) echo -e "\033[31mArchitecture not support\033[0m" && exit 1;; \
    esac && \
    wget "${url}/${arch}-${version}.tar.gz" && tar xf *.tar.gz && mv ./ajiasu /tmp/

FROM ${ALPINE_IMG}
COPY --from=asset /tmp/ajiasu /usr/bin
ENTRYPOINT ["ajiasu"]
