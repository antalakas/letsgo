FROM centos
MAINTAINER Andreas Ntalakas (antalakas@crypteianetworks.com)

# --- install git
RUN yum -y install git

# --- install unzip
RUN yum -y install unzip \
    && yum -y clean all

# --- install go
RUN cd tmp \
    && curl -OL https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.7.1.linux-amd64.tar.gz \
    && rm -rf go1.7.1.linux-amd64.tar.gz \
    && echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile

ENV PATH=$PATH:/usr/local/go/bin

# --- configure go
RUN mkdir -p ~/deploy/gospace
ENV GOPATH /root/deploy/gospace
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# --- install go deps
RUN go get github.com/Shopify/sarama
RUN go get github.com/go-sql-driver/mysql
RUN go get github.com/quipo/statsd
RUN go get github.com/parnurzeal/gorequest
RUN go get github.com/spf13/viper
RUN go get github.com/fatih/structs
RUN go get github.com/coreos/etcd/client
RUN go get gopkg.in/redis.v4
RUN go get gopkg.in/kataras/iris.v4
RUN go get github.com/codegangsta/gin

# --- prepare volume
VOLUME ["/cengine"]

# --- get sources
RUN mkdir -p "$GOPATH/src/gitlab.crypteianetworks.prv"
RUN cd "$GOPATH/src/gitlab.crypteianetworks.prv"
#RUN git clone git@10.104.38.150:CBF/stream-processor.git
#RUN git clone git@10.104.38.150:CBF/stream-mediator.git
#RUN git clone git@10.104.38.150:CBF/stream-threatdb.git
#RUN git clone git@10.104.38.150:CBF/stream-ruleset.git
#RUN git clone git@10.104.38.150:CBF/stream-va.git
#RUN git clone git@10.104.38.150:CBF/stream-common.git
#RUN git clone git@10.104.38.150:CBF/stream-counter.git

# --- compile cengine-cli
#RUN cd "$GOPATH/src/gitlab.crypteianetworks.prv/stream-processor"
#RUN go build cengine-cli.go

# --- copy compiled cengine-cli to volume
# to make it available to other containers as shared resource
#RUN cp "$GOPATH/src/gitlab.crypteianetworks.prv/stream-processor/cengine-cli" "/cengine"

# --- final bits
WORKDIR $GOPATH
CMD ["/bin/bash"]
