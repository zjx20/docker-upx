FROM --platform=$BUILDPLATFORM alpine:latest as curl
RUN apk add --no-cache curl
RUN curl -sSL $(curl -s https://api.github.com/repos/upx/upx/releases/latest \
    | grep browser_download_url | grep $BUILDARCH | cut -d '"' -f 4) -o /upx.tar.xz

FROM busybox:latest as extractor
WORKDIR /
COPY --from=curl /upx.tar.xz /
RUN tar -xf upx.tar.xz \
    && cd upx-*-$BUILDARCH_$TARGETOS \
    && mv upx /bin/upx

FROM scratch
COPY --from=extractor /bin/upx /bin/upx
ENTRYPOINT ["/bin/upx"]