FROM buildpack-deps:jessie-curl

RUN wget -q https://repos.influxdata.com/influxdb.key && \
    gpg --import influxdb.key && \
    rm -f influxdb.key

ENV KAPACITOR_VERSION 0.12.0
RUN wget -q https://s3.amazonaws.com/kapacitor/kapacitor_$KAPACITOR_VERSION-1_amd64.deb.asc && \
    wget -q https://s3.amazonaws.com/kapacitor/kapacitor_$KAPACITOR_VERSION-1_amd64.deb && \
    gpg --verify kapacitor_$KAPACITOR_VERSION-1_amd64.deb.asc kapacitor_$KAPACITOR_VERSION-1_amd64.deb && \
    dpkg -i kapacitor_$KAPACITOR_VERSION-1_amd64.deb && \
    rm -f kapacitor_$KAPACITOR_VERSION-1_amd64.deb*

EXPOSE 9092

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["kapacitord", "-config", "/etc/kapacitor/kapacitor.conf", "-log-file", "STDERR"]
