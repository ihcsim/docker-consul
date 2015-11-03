# docker-consul

Docker image of Consul.

### Tags

* 0.5.2

### Configurations

A set of default start-up configurations are found in the `config/base_config.json` file:

1. [Client address](https://www.consul.io/docs/agent/options.html#_client) is set to 0.0.0.0.
2. [Data directory](https://www.consul.io/docs/agent/options.html#_data_dir) is set to `/tmp/data`.
3. [Log level](https://www.consul.io/docs/agent/options.html#_log_level) is set to `INFO`. 

### Usage

* To pull: `docker pull isim/consul`
* To run first agent in server mode: `docker run -P --rm isim/consul agent -server -bootstrap-expect 1 -node agent01 -config-dir /opt/consul/config`
* To run second agent in non-server mode: `docker run --rm -P isim/consul agent -node agent-02 --config-dir /opt/consul/config`


### Key/Value Store

To test kv store:
  * Insert data: `curl -X PUT -d "myvalue" $DOCKER_HOST_IP:$MAPPED_PORT/v1/kv/mykey`
  * Look up key: `curl $DOCKER_HOST_IP:$MAPPED_PORT/v1/kv/mykey`
  * Delete key: `curl -X DELETE $DOCKER_HOST_IP:$MAPPED_PORT/v1/kv/mykey`

where:
* `$DOCKER_HOST_IP` is the IP address of `$DOCKER_HOST` as specified by `docker-machine env`.
* `MAPPED_PORT` is the host port that is mapped to the container's port 8500 as seen in `docker ps`.


### DNS API

To test the agent DNS API: `dig @$DOCKER_HOST_IP -p $MAPPED_PORT agent-02.node.consul`
where:
* `$DOCKER_HOST_IP` is the IP address of `$DOCKER_HOST` as specified by `docker-machine env`.
* `MAPPED_PORT` is the host port that is mapped to the container's port 8500 as seen in `docker ps`.

### Cluster Membership

To test cluster membership:
  1. Identify the first agent IP address: `docker inspect $AGENT1_CONTAINER_ID | grep IPAddress`
  2. Tell second agent to join first agent cluster: `docker exec $AGENT2_CONTAINER_ID consul join $AGENT1_IP_ADDRESS`
  3. To verify cluster membership: `docker exec $AGENT2_CONTAINTER_ID consul members`

You should see something like:

```
Node      Address          Status  Type    Build  Protocol  DC
agent-01  172.17.0.1:8301  alive   server  0.5.2  2         dc1
agent-02  172.17.0.3:8301  alive   client  0.5.2  2         dc1
```

### To Do's

Add instructions and configurations for:

* Verify sha256sum in Dockerfile
* Mounting volume for data directory
* Adding service and check definitions files
