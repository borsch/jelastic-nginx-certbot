FROM jelastic/nginxbalancer:1.26.2-almalinux-9
RUN dnf install -y epel-release certbot python3-certbot-nginx && \
    mv /etc/nginx/nginx.conf /etc/nginx/nginx-original.conf && \
    echo "/etc/letsencrypt" >> /etc/jelastic/redeploy.conf

COPY --chmod=0755 new-nginx-proxy.sh /usr/local/bin/new-nginx-proxy.sh
COPY nginx-override.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

CMD ["/usr/lib/systemd/systemd"]