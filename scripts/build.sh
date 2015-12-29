export HOME=/root
cd

apk update
apk add nginx supervisor python python-dev py-pip build-base postgresql-dev openldap-dev cyrus-sasl-dev libxml2-dev libxslt-dev gettext curl libxml2 libxslt libsasl libldap libpq uwsgi

curl -L 'https://github.com/tildaslash/RatticWeb/archive/v1.3.1.tar.gz' -o rattic.tar.gz

mkdir -p /srv/rattic

tar -zxvf "$HOME/rattic.tar.gz" -C /srv/rattic 

mv /srv/rattic/RatticWeb-*/* /srv/rattic/

rm -fv "$HOME/rattic.tar.gz"

# Temporary fix for SOUTH_MIGRATION_MODULES exception
echo "kombu==3.0.26" >> /srv/rattic/requirements-base.txt
sed -i /srv/rattic/requirements-base.txt -e 's/django-celery>=3.1,<3.2/django-celery>=3.1,<3.1.17/g'

pip install -r /srv/rattic/requirements-pgsql.txt
pip install jinja2 envtpl

apk del python-dev py-pip build-base postgresql-dev openldap-dev cyrus-sasl-dev libxml2-dev libxslt-dev curl 

apk cache clean 
rm -rvf /var/tmp/*
rm -rvf /tmp/*
