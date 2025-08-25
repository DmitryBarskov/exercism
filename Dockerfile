ARG TARGET_IMAGE=alpine

FROM --platform=$BUILDPLATFORM alpine AS build

ARG BUILDPLATFORM
ARG TARGETARCH
ARG TARGETOS

WORKDIR /root
RUN wget -O exercism.tar.gz \
  "https://github.com/exercism/cli/releases/download/v3.4.0/exercism-3.4.0-$TARGETOS-$TARGETARCH.tar.gz"
RUN tar -xf exercism.tar.gz

FROM $TARGET_IMAGE
ARG TARGET_IMAGE
ARG UID
ARG GID

COPY --from=build /root/exercism /bin/exercism

# Use instructions below for alpine based images
RUN addgroup -g $GID exercist || \
  adduser -S -u $UID -G $(getent group $GID | cut -d: -f1) exercist

# Use instruction below for debian based images
# RUN groupadd -g $GID exercist || \
#  useradd -m -r -o -u $UID -g exercist exercist

USER exercist
WORKDIR /home/exercist

RUN mkdir -p /home/exercist/.config/exercism
RUN touch /home/exercist/.config/exercism/user.json
