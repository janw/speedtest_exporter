module github.com/nlamirault/speedtest_exporter

require (
	github.com/dchest/uniuri v0.0.0-20160212164326-8902c56451e9
	github.com/prometheus/client_golang v0.9.1
	github.com/prometheus/common v0.0.0-20190107103113-2998b132700a
	github.com/urfave/cli v1.22.4 // indirect
	github.com/zpeters/speedtest v1.0.3
)

go 1.13

replace github.com/nlamirault/speedtest_exporter => github.com/janw/speedtest_exporter v0.3.1-0.20200529121232-139dcf9e67cc
