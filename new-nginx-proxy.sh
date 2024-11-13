#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -d DOMAIN_VALUE -ft FORWARD_TO"
   echo -e "\t-d - name of the domain that should be proxied. Example - my-domain.example.com"
   echo -e "\t-ft - fully specified url to external service to which requests should be proxied"
   exit 1 # Exit script after printing help
}

while getopts "d:p:" opt
do
   case "$opt" in
      d ) domain="$OPTARG" ;;
      ft ) forward_to="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$domain" ] || [ -z "$forward_to" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

nginx_site_file="/etc/nginx/conf.d/$domain.conf"


echo "writing default nginx proxy server to $nginx_site_file"

tee $nginx_site_file << END
server {
        server_name $domain;
        access_log /var/log/nginx/$domain-access.log;
        error_log /var/log/nginx/$domain-error.log;

        location / {
                proxy_set_header   Connection "";
                proxy_http_version 1.1;
                proxy_set_header        Host            \$host;
                proxy_set_header        X-Real-IP       \$remote_addr;
                proxy_set_header        X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_set_header        Upgrade         \$http_upgrade;
                proxy_set_header        Connection      "upgrade";
                proxy_pass          $forward_to;
                proxy_read_timeout  90;
        }
}

END

echo ""
echo "verifying nginx config"
nginx -t

echo ""
echo "installing SSL servificate. Certbot might want some input from you during installation"
certbot --nginx -d $domain

echo "proxy and SSL configured. you can restart nginx now"
