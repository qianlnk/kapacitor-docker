FROM alpine:3.3

RUN apk add --update ca-certificates wget gnupg tar && \
    rm /var/cache/apk/*

RUN gpg --keyserver hkp://ha.pool.sks-keyservers.net \
    --recv-keys 05CE15085FC09D18E99EFB22684A14CF2582E0C5

RUN wget -q https://dl.influxdata.com/kapacitor/nightlies/kapacitor-static-nightly_linux_amd64.tar.gz && \
    wget -q https://dl.influxdata.com/kapacitor/nightlies/kapacitor-static-nightly_linux_amd64.tar.gz.asc && \
    gpg --batch --verify kapacitor-static-nightly_linux_amd64.tar.gz.asc kapacitor-static-nightly_linux_amd64.tar.gz && \
    tar -xvzf kapacitor-static-nightly_linux_amd64.tar.gz && \
    mv -v kapacitor*/* / && \
    rm -rf kapacitor-static-nightly_linux_amd64.tar.gz

EXPOSE 9092

VOLUME /var/lib/kapacitor

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/kapacitord"]
