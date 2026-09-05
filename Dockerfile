ARG TARGET_IMAGE=alpine

FROM --platform=$BUILDPLATFORM alpine AS build

ARG BUILDPLATFORM
ARG TARGETARCH
ARG TARGETOS

ARG EXERCISM_VERSION="3.5.8"

WORKDIR /root
RUN wget -O exercism.tar.gz \
  "https://github.com/exercism/cli/releases/download/v$EXERCISM_VERSION/exercism-$EXERCISM_VERSION-$TARGETOS-$TARGETARCH.tar.gz"
RUN tar -xf exercism.tar.gz

FROM $TARGET_IMAGE

COPY --from=build /root/exercism /bin/exercism

RUN mkdir -p /home/exercist/.config/exercism && \
  touch /home/exercist/.config/exercism/user.json && \
  chmod -R 1777 /home/exercist

WORKDIR /home/exercist
