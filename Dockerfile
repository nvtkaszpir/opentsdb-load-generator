FROM golang:alpine as builder
RUN mkdir /build 
ADD . /build/
WORKDIR /build 
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o opentsdb-load-generator .

FROM ubuntu:20.04
COPY --from=builder /build/opentsdb-load-generator /app/

# number of connections to opentsdb
ENV CONN=1
# metric name to generate
ENV METRIC=test.metric
# number of datapoints per second to send
ENV RATE=1000
# opentsdb address
ENV TSDB="localhost:4242"
WORKDIR /app

CMD ["/bin/bash", "-c", "/app/opentsdb-load-generator -conn $CONN -metric $METRIC -rate $RATE -tsdb $TSDB"]
