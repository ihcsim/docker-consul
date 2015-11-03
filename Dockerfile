FROM ubuntu:precise
MAINTAINER Ivan Sim, ihcsim@gmail.com

# install binaries
RUN apt-get update && \
    apt-get install -y \
      wget \
      zip && \
    wget --no-check-certificate https://releases.hashicorp.com/consul/0.5.2/consul_0.5.2_linux_amd64.zip && \
    unzip -d /opt/consul/ consul_0.5.2_linux_amd64.zip && \
    ln -s /opt/consul/consul /usr/bin/consul

COPY config /opt/consul/config/

# Refer https://www.consul.io/docs/agent/options.html for ports used by consul
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600/tcp 8600/udp

ENTRYPOINT ["consul"] 
