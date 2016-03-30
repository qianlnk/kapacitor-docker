FROM debian:jessie

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    apt-transport-https \
    gnupg \
    wget

RUN wget https://repos.influxdata.com/influxdb.key && \
    gpg --import influxdb.key && \
    rm -f influxdb.key

ENV KAPACITOR_VERSION 0.11.0
RUN wget https://s3.amazonaws.com/kapacitor/kapacitor_$KAPACITOR_VERSION-1_amd64.deb.asc && \
    wget https://s3.amazonaws.com/kapacitor/kapacitor_$KAPACITOR_VERSION-1_amd64.deb && \
    gpg --verify kapacitor_$KAPACITOR_VERSION-1_amd64.deb.asc kapacitor_$KAPACITOR_VERSION-1_amd64.deb && \
    dpkg -i kapacitor_$KAPACITOR_VERSION-1_amd64.deb && \
    rm -f kapacitor_$KAPACITOR_VERSION-1_amd64.deb*

EXPOSE 9092

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["kapacitord", "-config", "/etc/kapacitor/kapacitor.conf", "-log-file", "STDERR"]
