# Kapacitor
Kapacitor is a data processing engine. It can process both stream and batch data. 

## Using this image
Following example uses Kapacitor along with InfluxDB and Telegraf

Start influxdb container
```
docker run --net=host  influxdb
```
Verify that influxdb is running by accessing the WEB admin interface [http://localhost:8083/](http://localhost:8083/)

Create following config file 'telegraf.conf'
```
[agent]
    interval = "1s"
[outputs]
# Configuration to send data to InfluxDB.
[outputs.influxdb]
    urls = ["http://localhost:8086"]
    database = "kapacitor_example"
    user_agent = "telegraf"
# Collect metrics about cpu usage
[cpu]
    percpu = false
    totalcpu = true
    drop = ["cpu_time"]
```
Start telegraf using the above config. In this example telegraf runs on the host and not in a docker container.
```
telegraf -config telegraf.conf
```
Again check influxdb via the WEB admin interface [http://localhost:8083/](http://localhost:8083/). A database by the name "kapacitor_example" should be added.

Start the kapacitor container
```
docker run -i --name kapacitor  --net=host -v /path/on/host/kapFiles/:/root/ kapacitor
```
Use ```docker exec``` to run a command in the existing container
```
docker exec -it KAPACITOR_CONTAINER_ID bash
```
```$(docker ps | awk '{if ($2 == "kapacitor") print $1}')``` gives the ID for the kapacitor container. You can also find the id by ```docker ps```

- On the host machine  create a file cpu_alert.tick at ```/path/on/host/kapFiles/``` which  is mounted at /root/ on the kapacitor container
```
stream
    // Select just the cpu measurement from our example database.
    .from().measurement('cpu')
    .alert()
        .crit(lambda: "usage_idle" < 100 )
        // Whenever we get an alert write it to a file.
        .log('/root/alerts.log')
```

- In the kapacitor container run the following commands
      - ``` cd /root/```
      - ```ls             # Check you have the cpu_alert.tick listed ```
      - ```kapacitor define -name cpu_alert -type stream -tick cpu_alert.tick -dbrp kapacitor_example.default```
      - ```rid=$(kapacitor record stream -name cpu_alert -duration 20s)```
      - ```kapacitor list recordings $rid #Confirm recording captured data``` 
      - ```kapacitor replay -id $rid -name cpu_alert -fast #Replay data to task```
      - ```cat /root/alerts.log  #Check the log ``` 
      - ```kapacitor enable cpu_alert #Enable the alert to start processing live data ```
      - ```kapacitor show cpu_alert```


See [this](https://docs.influxdata.com/kapacitor/v0.10/introduction/getting_started/) for a more detailed description of steps involved in this example
