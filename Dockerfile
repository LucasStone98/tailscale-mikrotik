FROM alpine:latest

WORKDIR /app/ts

ARG TARGETARCH

RUN apk add --no-cache iptables ip6tables iproute2 ca-certificates

# Use legacu iptables
RUN ln -s /sbin/iptables-legacy /sbin/iptables && ln -s /sbin/ip6tables-legacy /sbin/ip6tables 

# Download latest tailscale bin from pkgs.tailscale.com
RUN wget https://pkgs.tailscale.com/stable/tailscale_latest_${TARGETARCH}.tgz && \
    tar xzf tailscale_latest_${TARGETARCH}.tgz --strip-components=1 && \
    rm tailscale_latest_${TARGETARCH}.tgz && \
    ln -s /app/ts/tailscale /usr/bin/tailscale

COPY entrypoint.sh /app/ts/entrypoint.sh
RUN chmod +x /app/ts/entrypoint.sh

ENTRYPOINT ["/bin/sh", "/app/ts/entrypoint.sh"]
