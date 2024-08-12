ARG TARGET_IMAGE

FROM --platform=$BUILDPLATFORM alpine AS build

ARG BUILDPLATFORM
ARG TARGETARCH
ARG TARGETOS

WORKDIR /root
RUN wget -O exercism.tar.gz "https://github.com/exercism/cli/releases/download/v3.4.0/exercism-3.4.0-$TARGETOS-$TARGETARCH.tar.gz"
RUN tar -xf exercism.tar.gz

FROM $TARGET_IMAGE
ARG TARGET_IMAGE
COPY --from=build /root/exercism /bin/exercism
