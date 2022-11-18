FROM debian:11-slim
MAINTAINER zs

ADD nginx-1.22.1.tar.gz /usr/local
ADD v0.0.3.tar.gz /usr/local
COPY proxy_connect_rewrite_102101.patch /usr/local

RUN set -e \
	&& apt-get update \
	&& apt-get install patch -y \
	&& apt-get install gcc make libpcre3-dev -y \
	&& cd /usr/local/nginx-1.22.1 \
	&& patch -p1 < /usr/local/proxy_connect_rewrite_102101.patch \
	&& ./configure --add-module=/usr/local/ngx_http_proxy_connect_module-0.0.3 --prefix=/etc/nginx \
	&& make && make install \
	&& ln -s /etc/nginx/bin/nginx /usr/bin/nginx

CMD ["nginx"]
