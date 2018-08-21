# docker-nginx-accessfabric
[![Travis (.org)](https://img.shields.io/travis/obviateio/docker-nginx-accessfabric.svg?style=for-the-badge)](https://travis-ci.org/obviateio/docker-nginx-accessfabric)  [![GitHub issues](https://img.shields.io/github/issues-raw/obviateio/docker-nginx-accessfabric.svg?style=for-the-badge)](https://github.com/obviateio/docker-nginx-accessfabric)  [![GitHub](https://img.shields.io/github/license/obviateio/docker-nginx-accessfabric.svg?style=for-the-badge)](https://github.com/obviateio/docker-nginx-accessfabric)  [![GitHub stars](https://img.shields.io/github/stars/obviateio/docker-nginx-accessfabric.svg?style=for-the-badge&label=Stars)](https://github.com/obviateio/docker-nginx-accessfabric)  [![GitHub last commit](https://img.shields.io/github/last-commit/obviateio/docker-nginx-accessfabric.svg?style=for-the-badge)](https://github.com/obviateio/docker-nginx-accessfabric)  [![Docker Stars](https://img.shields.io/docker/stars/shakataganai/nginx-accessfabric.svg?style=for-the-badge)](https://hub.docker.com/r/shakataganai/nginx-accessfabric/)  [![Docker Pulls](https://img.shields.io/docker/pulls/shakataganai/nginx-accessfabric.svg?style=for-the-badge)](https://hub.docker.com/r/shakataganai/nginx-accessfabric/)  [![MicroBadger Layers](https://img.shields.io/microbadger/layers/shakataganai/nginx-accessfabric.svg?style=for-the-badge)](https://hub.docker.com/r/shakataganai/nginx-accessfabric/)


[Nginx](https://www.nginx.com/) + [ngx_http_auth_accessfabric](https://github.com/ScaleFT/nginx_auth_accessfabric) + [miniubuntu](https://hub.docker.com/r/shakataganai/miniubuntu/)

A compiled-from-source copy of nginx with the [ScaleFT](https://www.scaleft.com/) module for their [Access Fabric](https://www.scaleft.com/access-fabric/) product. This container requires you provide your own TLS certificates. If you want to use LetsEncrypt/Certbot, see [obviateio/docker-nginx-accessfabric](https://github.com/obviateio/docker-nginx-accessfabric).


# Usage
* Login to [ScaleFT](https://app.scaleft.com/)
* Create a project 
* Go into that project & create an application
* Verify your origin URL (ex: `gitlab.ext.company.tld`) is in DNS and externally resolveable
* Cname the custom hostname (ex: `gitlab.company.tld`) to the application URL (ex: `random-words-1234.accessfabric.com`)
* mkdir ./conf.d/
* Add a `.conf` such as (ex: `./conf.d/gitlab.conf`):
```nginx
server {
    auth_accessfabric	on;
    auth_accessfabric_audience "https://random-words-1234.accessfabric.com";
    listen              443 ssl;
    server_name         gitlab.ext.company.tld gitlab.company.tld random-words-1234.accessfabric.com";
    ssl_certificate     /etc/nginx/conf.d/gitlab.ext.company.tld-fullchain.pem;
    ssl_certificate_key /etc/nginx/conf.d/gitlab.ext.company.tld-privkey.pem;

    location / {
        proxy_pass http://gitlabinstance.company.int:80;
    }
}
```
* Run docker container: 
```
docker run --name=nginx \
 -v /home/myuser/conf.d/:/etc/nginx/conf.d/ \
 -p 80:80 -p 443:443 \
 --restart=always \
 -d shakataganai/nginx-accessfabric-certbot:latest
```