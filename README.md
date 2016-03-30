# Kapacitor

Kapacitor is a data processing engine. It can process both stream and batch data.

## Using this image

Start the Kapacitor container with default options:

	docker run --net=host -v /path/on/host/kapacitorFiles/:/var/lib/kapacitor kapacitor

Start the Kapacitor container with custom configuration.

    docker run --net=host -v /path/on/host/kapacitor.config:/etc/kapacitor/kapacitor.conf:ro -v /path/on/host/kapacitorFiles/:/var/lib/kapacitor kapacitor

Start the Kapacitor container with custom configuration using env vars.

    docker run --net=host -e KAPACITOR_LOGGING_LEVEL=DEBUG -v /path/on/host/kapacitorFiles/:/var/lib/kapacitor kapacitor


## Using the CLI

The kapacitor CLI binary is also included in the image.
To start a container for communicating with the kapacitor daemon, change the entrypoint

    docker run -it --entrypoint=bash -v /path/on/host/kapacitorFiles/:/var/lib/kapacitor kapacitor

Then from within the container you can use the `kapacitor` command to interact with the daemon.
Assuming you have Telegraf + InfluxDB + Kapacitor all hooked up,
then create a file `cpu_alert.tick`.
If not then see the [docker-compose](https://docs.docker.com/compose/) [TICK stack](https://github.com/influxdata/TICK-docker) environment for easy setup.

```sh
cat > cpu_alert.tick << EOF
stream
    // Select just the cpu measurement from our example database.
    |from()
        .measurement('cpu')
    |alert()
        .crit(lambda: "usage_idle" < 100 )
        // Whenever we get an alert notify slack
        .slack()
EOF
```

Then define, enable and watch the status of the task:

    kapacitor define -name cpu_alert -type stream -dbrp telegraf.default -tick cpu_alert.tick
    kapacitor enable cpu_alert
    kapacitor show cpu_alert


See [this](https://docs.influxdata.com/kapacitor/latest/introduction/getting_started/) for a more detailed guide.

## Supported Docker versions

This image is officially supported on Docker version 1.10.1
