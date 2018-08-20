FROM shakataganai/miniubuntu:latest

LABEL MAINTAINER "Jon 'ShakataGaNai' Davis"

ENV NGINX_VER 1.15.2

RUN installpkg build-essential git tree wget curl automake autoconf autoconf-archive \
  libjansson-dev libssl-dev build-essential libtool curl libcurl4-openssl-dev \
  libgd-dev libgeoip-dev libjansson-dev libpcre3-dev libssl-dev libxslt-dev openssl  \
  zlib1g-dev 

RUN git clone https://github.com/ScaleFT/libxjwt.git \
  && git clone https://github.com/ScaleFT/nginx_auth_accessfabric.git \
  && wget https://nginx.org/download/nginx-$NGINX_VER.tar.gz

RUN cd libxjwt \ 
  && ./buildconf.sh && ./configure \
  && make && make install

RUN cd .. \
  && tar zxvf nginx-$NGINX_VER.tar.gz \
  && cd ../nginx-$NGINX_VER \
  && ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-http_xslt_module=dynamic --with-http_image_filter_module=dynamic --with-http_geoip_module=dynamic --with-threads --with-stream --with-stream_ssl_module --with-stream_ssl_preread_module --with-stream_realip_module --with-stream_geoip_module=dynamic --with-http_slice_module --with-mail --with-mail_ssl_module --with-compat --with-file-aio --with-http_v2_module --add-dynamic-module="../nginx_auth_accessfabric" \
  && make && make install

RUN useradd nginx \
  && ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log \
  && mkdir -p /var/cache/nginx/client_temp

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
