FROM buildpack-deps:jessie-curl

RUN gpg \
    --keyserver hkp://ha.pool.sks-keyservers.net \
    --recv-keys 05CE15085FC09D18E99EFB22684A14CF2582E0C5

RUN wget -q https://dl.influxdata.com/kapacitor/nightlies/kapacitor_nightly_amd64.deb.asc && \
    wget -q https://dl.influxdata.com/kapacitor/nightlies/kapacitor_nightly_amd64.deb && \
    gpg --batch --verify kapacitor_nightly_amd64.deb.asc kapacitor_nightly_amd64.deb && \
    dpkg -i kapacitor_nightly_amd64.deb && \
    rm -f kapacitor_nightly_amd64.deb*

EXPOSE 9092

VOLUME /var/lib/kapacitor

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["kapacitord"]
