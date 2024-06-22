FROM node:alpine as build

RUN apk add --update --no-cache \
	git \
	make \
    g++ \
    jpeg-dev \
    cairo-dev \
    giflib-dev \
    pango-dev \
    libtool \
    autoconf \
    automake && \
	apk add openjdk21 --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community && \
	apk add babashka --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

WORKDIR /build

COPY *.json *.edn index.mjs ./
COPY src ./src

RUN npm install
RUN ./node_modules/@logseq/nbb-logseq/cli.js -e ''

FROM node:alpine

WORKDIR /app

RUN apk add --update \
    jpeg \
    cairo \
    giflib \
    pango

COPY --from=build /build .

ENTRYPOINT ["node", "index.mjs"]
