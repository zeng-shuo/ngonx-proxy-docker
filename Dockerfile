FROM debian:11-slim
MAINTAINER zs

ADD nginx-1.22.1.tar.gz /usr/local/
ADD v0.0.3.tar.gz /usr/local/
COPY proxy_connect_rewrite_102101.patch /usr/local/

WORKDIR /usr/local/nginx-1.22.1
RUN set -e \
	&& apt-get update \
	&& apt-get install patch -y \
	&& apt-get install gcc make libpcre3-dev zlib1g zlib1g-dev libssl-dev vim -y \
	&& patch -p1 < /usr/local/proxy_connect_rewrite_102101.patch \
	&& ./configure --add-module=/usr/local/ngx_http_proxy_connect_module-0.0.3 --prefix=/etc/nginx \
	&& make && make install \
	&& ln -s /etc/nginx/sbin/nginx /usr/bin/nginx \
	&& ln -sf /dev/stdout /etc/nginx/logs/access.log \
    	&& ln -sf /dev/stderr /etc/nginx/logs/error.log
	
COPY nginx.conf /etc/nginx/conf/
COPY htpasswd /etc/nginx/conf/
COPY default.conf /etc/nginx/conf.d/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
