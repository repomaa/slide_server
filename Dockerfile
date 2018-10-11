FROM alpine:latest
RUN apk update && apk add alpine-sdk crystal shards musl-dev yaml-dev libxml2-dev libressl-dev zlib-dev git

RUN mkdir -p /opt/slide_server
WORKDIR /opt/slide_server

ADD public ./public
ADD shard.yml shard.lock ./
RUN shards install --production
ADD src ./src
RUN shards build --production --static --release slide_server
RUN mkdir /opt/slide_server/slides

FROM scratch
COPY --from=0 /opt/slide_server/bin/slide_server /bin/slide_server
COPY --from=0 /opt/slide_server/slides /slides
VOLUME /slides
EXPOSE 3000
ENV SLIDE_SERVER_HOST=0.0.0.0
CMD ["/bin/slide_server", "/slides"]
