FROM ubuntu:12.04

RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy build-essential curl git
RUN curl -s https://go.googlecode.com/files/go1.2.1.src.tar.gz | tar -v -C /usr/local -xz
RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1
ENV PATH /usr/local/go/bin:$PATH
ENV GOROOT /usr/local/go
ENV GOPATH /work
RUN go get github.com/coreos/go-etcd/etcd
RUN go get github.com/miekg/dns
RUN go get github.com/jkingyens/helixdns
RUN cd /work && go install ./src/github.com/jkingyens/helixdns/cmd/hdns
EXPOSE 53/udp
ENTRYPOINT [ "/work/bin/hdns", "-port=53", "-forward=8.8.8.8:53", "-etcd-address=http://172.17.42.1:4001" ]
