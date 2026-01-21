#!/bin/sh

# System proxy:
proxy=DIRECT
[ "$proxy" = DIRECT ] || export http_proxy="http://$proxy" https_proxy="http://$proxy" ftp_proxy="http://$proxy"

# Proxy exceptions:
#noproxy=
[ "$noproxy" ] && export no_proxy="localhost,127.0.0.1,$noproxy" || export no_proxy="localhost,127.0.0.1"
