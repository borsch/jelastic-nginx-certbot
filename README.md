# jelastic-nginx-certbot

This image is created based on [jelastic/nginxbalancer](https://hub.docker.com/r/jelastic/nginxbalancer). This image contains installed certbot along with scripts to quickly configure nginx proxies

### Usage
After installation load balancer using custom docker image from [olehkurpiak/jelastic-nginx-certbot](https://hub.docker.com/r/olehkurpiak/jelastic-nginx-certbot) you can run following commang to setup proxy and install SSL
```sh
new-nginx-proxy.sh -d my-domain.example.com -f http://custom-jelastic-env.jelastic-provider.com:8081
```

This command will create file `my-domain.example.com` under `/etc/nginx/conf.d/` and will install SSL for this domain. Once installation is successfull you would need to restart nginx node

