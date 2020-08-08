# Copyright (C) 2016-2019 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:alpine as builder

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
ENV GO111MODULE=on

RUN apk update \
    && apk add --no-cache git ca-certificates tzdata \
    && update-ca-certificates \
    && mkdir -p /build/etc \
    && echo 'nobody:x:65534:65534:nobody:/:/sbin/nologin' > /build/etc/passwd

WORKDIR ${GOPATH}/src/app

COPY go.* speedtest_exporter* ./
COPY speedtest ./speedtest

RUN go mod download \
    && go mod verify
RUN go build -a -installsuffix cgo \
    -ldflags="-w -s -X 'main.BuildTime=$(date -Iseconds --utc)'" \
    -o /build/speedtest_exporter

# --------------------------------------------------------------------------------

FROM scratch
LABEL summary="Speedtest Prometheus exporter" \
      description="A Prometheus exporter for speedtest.net tests" \
      name="janwh/speedtest_exporter" \
      url="https://github.com/janw/speedtest_exporter" \
      maintainer="Jan Willhaus <mail@janwillhaus.de>"


COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /build /
USER nobody

EXPOSE 9112

ENTRYPOINT [ "/speedtest_exporter" ]
