FROM ubuntu:precise
MAINTAINER Ivan Sim, ihcsim@gmail.com

ENV CONSUL_VERSION 0.6.0
ENV CONSUL_SHA256 307fa26ae32cb8732aed2b3320ed8daf02c28b50d952cbaae8faf67c79f78847

# install binaries
RUN apt-get update && \
    apt-get install -y \
      wget \
      zip && \
    wget --no-check-certificate https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    echo "$CONSUL_SHA256  consul_${CONSUL_VERSION}_linux_amd64.zip" > consul.sha256 && \
    sha256sum -c consul.sha256 && \
    unzip -d /opt/consul/ consul_${CONSUL_VERSION}_linux_amd64.zip && \
    ln -s /opt/consul/consul /usr/bin/consul && \
    rm consul_${CONSUL_VERSION}_linux_amd64.zip consul.sha256

COPY config /opt/consul/config/

# Refer https://www.consul.io/docs/agent/options.html for ports used by consul
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600/tcp 8600/udp

ENTRYPOINT ["consul"] 
