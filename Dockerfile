FROM alpine:latest
MAINTAINER Benoît Pourre <benoit.pourre@gmail.com>

COPY scripts/* /scripts/
RUN sh /scripts/build.sh

EXPOSE 8000/tcp
VOLUME ["/srv/rattic"]
WORKDIR /srv/rattic

# nginx site conf
RUN rm -Rf /etc/nginx/conf.d/* && mkdir /etc/nginx/sites-enabled 

ADD ./nginx.conf /etc/nginx/nginx.conf
COPY ./conf.d /etc/nginx/
ADD ./nginx-site.conf /etc/nginx/sites-enabled/default.conf

# Supervisor Config
ADD ./supervisord.conf /etc/supervisord.conf

COPY conf/* /usr/local/etc/rattic/

ENTRYPOINT ["sh", "/scripts/entrypoint.sh"]
