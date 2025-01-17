FROM golang:1.16 as builder
COPY . /go/src/github.com/urbitechsro/docker-volume-glusterfs
WORKDIR /go/src/github.com/urbitechsro/docker-volume-glusterfs
RUN go mod vendor
RUN go install --ldflags '-extldflags "-static"'
CMD ["/go/bin/docker-volume-glusterfs"]

FROM ubuntu:20.04

ARG glusterfs_version

RUN apt-get update \
  && apt-get install software-properties-common -y \
  && add-apt-repository ppa:gluster/glusterfs-${glusterfs_version} \
  && apt-get update \
  && apt-get install glusterfs-client -y \
  && apt-get purge software-properties-common -y \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*
COPY --from=builder /go/bin/docker-volume-glusterfs .
CMD ["./docker-volume-glusterfs"]