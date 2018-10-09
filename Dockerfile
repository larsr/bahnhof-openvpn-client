FROM alpine
MAINTAINER Lars Rasmusson <lars.rasmusson@gmail.com>

# Modified from https://github.com/dperson/openvpn-client

# Install openvpn
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl ip6tables iptables openvpn \
                shadow tini && \
    addgroup -S vpn && \
    rm -rf /tmp/*

# copy config files
COPY vpn /vpn

HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
             CMD curl -L 'https://api.ipify.org'


ENTRYPOINT ["/sbin/tini", "--", "sg", "vpn", "-c", "openvpn --config /vpn/bahnhof.conf"]
