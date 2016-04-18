# Kapacitor

Kapacitor is an open source data processing engine written in Go. It can process both stream and batch data.

[Kapacitor Official Documentation](https://docs.influxdata.com/kapacitor/latest/introduction/getting_started/)

%%LOGO%%

## Using this image

### Using the default configuration

Start the Kapacitor container with default options:

```console
$ docker run -p 9092:9092 \
    -v $PWD:/var/lib/kapacitor \
    kapacitor
```

Modify `$PWD` to the directory where you want to store data associated with the Kapacitor container.

You can also have Docker control the volume mountpoint by using a named volume.

```console
docker run -p 9092:9092 \
    -v kapacitor:/var/lib/kapacitor \
    kapacitor
```

### Configuration

Kapacitor can be either configured from a config file or using environment variables. To mount a configuration file and use it with the server, you can use this command:

Generate the default configuration file:

```console
$ docker run --rm kapacitor kapacitord config > kapacitor.conf
```

Modify the default configuration, which will now be available under `$PWD`. Then start the Kapacitor container.

```console
$ docker run -p 9092:9092 \
      -v $PWD:/etc/kapacitor:ro \
      kapacitord -config /etc/kapacitor/kapacitor.conf
```

Modify `$PWD` to the directory where you want to store the configuration file.

For environment variables, the format is `KAPACITOR_$SECTION_$NAME`. All dashes (`-`) are replaced with underscores (`_`). If the variable isn't in a section, then omit that part.

Examples:

```console
KAPACITOR_HOSTNAME=kapacitor
KAPACITOR_LOGGING_LEVEL=INFO
KAPACITOR_REPORTING_ENABLED=false
```

Find more about configuring Kapacitor [here](https://docs.influxdata.com/kapacitor/latest/introduction/installation/)

### Exposed Ports

-	9092 TCP -- HTTP API endpoint

#### Subscriptions

If you are using subscriptions then Kapacitor will listen on whichever ports are defined in InfluxDB `SHOW SUBSCRIPTIONS`. Subscriptions can be created explicitly for Kapacitor via the `CREATE SUBSCRIPTION` command. If subscriptions have not already been created when Kapacitor starts up then they will be created automatically and a dynamic port will be chosen. In that case you will want to launch the InfluxDB container and link it to the Kapacitor container.

```console
# Start the Kapacitor container, set KAPACITOR_HOSTNAME to the container name/hostname.
$ docker run -p 9092:9092 \
    --name kapacitor \
    -h kapacitor \
    -e KAPACITOR_HOSTNAME=kapacitor \
    -e KAPACITOR_INFLUXDB_0_URLS_0=http://$HOSTNAME:8086 \
    -v kapacitor:/var/lib/kapacitor \
    kapacitor

# Start the InfluxDB container linked to Kapacitor
docker run -p 8083:8083 -p 8086:8086 \
    --name influxdb \
    --link=kapacitor \
    -v influxdb:/var/lib/influxdb \
    influxdb
```

Modify `$HOSTNAME` with a valid hostname for connecting to InfluxDB.

>	NOTE: Kapacitor will wait up to a default of 5 minutes for InfluxDB to startup. The startup timeout can be configured via the `startup-timeout` option in the `[[influxdb]]` section.


### CLI / SHELL

Start the container:

```console
$ docker run --name=kapacitor -d -p 9092:9092 kapacitor
```

Run another container linked to the `kapacitor` container for using the client. Set the env `KAPACITOR_URL` so the client knows how to connect to Kapacitor. Mount in your current directory for accessing TICKscript files.

```console
$ docker run --rm --link=kapacitor \
    -e KAPACITOR_URL=http://kapacitor:9092 \
    -v $PWD:/root -w=/root -it \
    kapacitor bash
```

Then from within the container you can use the `kapacitor` command to interact with the daemon. Assuming you have Telegraf + InfluxDB + Kapacitor all hooked up, then create a file `cpu_alert.tick`. If not then see the [docker-compose](https://docs.docker.com/compose/) [TICK stack](https://github.com/influxdata/TICK-docker) environment for easy setup.

```sh
cat > cpu_alert.tick << EOF
stream
    // Select just the cpu measurement from our example database.
    |from()
        .measurement('cpu')
    |alert()
        .crit(lambda: "usage_idle" < 100)
        // Whenever we get an alert write it to a log file.
        .log('/root/alert.log')
EOF
```

Then define, enable and watch the status of the task:

```console
kapacitor define -name cpu_alert -type stream -dbrp telegraf.default -tick cpu_alert.tick
kapacitor enable cpu_alert
kapacitor show cpu_alert
```

See [this](https://docs.influxdata.com/kapacitor/latest/introduction/getting_started/) for a more detailed getting started guide with Kapacitor.
