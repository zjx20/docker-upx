FROM --platform=$BUILDPLATFORM alpine:latest as build
ARG TARGETOS TARGETARCH
RUN apk add --no-cache curl
RUN curl -sSL $(curl -s https://api.github.com/repos/upx/upx/releases/latest \
    | grep browser_download_url | grep $TARGETARCH | cut -d '"' -f 4) -o /upx.tar.xz
RUN tar -xf /upx.tar.xz \
    && cd upx-*-$TARGETARCH_$TARGETOS \
    && mv upx /bin/upx

FROM scratch
COPY --from=build /bin/upx /bin/upx
ENTRYPOINT ["/bin/upx"]
