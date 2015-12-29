# captnbp/docker-ratticdb
[RatticDB](http://rattic.org/) for Docker with a Postgresql DB, Nginx and uWSGI above a small [Alpine Linux](http://alpinelinux.org/)

**NOTE:**  SSL is not activated as this Docker is intended to be behind a SSL Proxy like Nginx for example.
## TODO
  * Add LDAP configuration
## Build
```shell
docker build -t $USER/ratticdb:1.3.1 .
```
## First run
For the first run, you need to :
### Create a [Docker Network ](https://docs.docker.com/engine/userguide/networking/)
```shell
docker network create -d bridge ratticdb
```
### Run the DB
```shell
docker run -d \
  --net=ratticdb \
  --name 'ratticdb-postgres' \
  -e POSTGRES_USER=ratticdb \
  -e POSTGRES_PASSWORD=changeme \
  -e POSTGRES_DB=ratticdb \
  -v /src/ratticdb/postgresql:/var/lib/postgresql/data \
  postgres
```

### Init the DB
```shell
docker run --rm=true \
  --name 'ratticdb' \
  --net=ratticdb \
  -e 'DB_HOST=ratticdb-postgres' \
  -e 'DB_PORT=5432' \
  -e 'DB_USER=ratticdb' \
  -e 'DB_PASSWORD=changeme' \
  -e 'DB_NAME=ratticdb' \
  -e 'TIMEZONE=UTC' \
  -e 'VIRTUAL_HOST=somedomain.example.com' \
  -e 'SECRETKEY=someverysecretkeyforsessions' \
  -e 'MAIL_HOST=smtp.example.com' \
  -e 'MAIL_PORT=587' \
  -e 'MAIL_USER=example@example.com' \
  -e 'MAIL_PASSWORD=someemailpassword' \
  -e 'MAIL_FROM=emailed-from@example.com' \
  -e 'MAIL_ENABLE_TLS=true' \
  $USER/ratticdb:1.3 init
```
### Run RatticDB
```shell
docker run -d \
  --name 'ratticdb' \
  --net=ratticdb \
  -e 'DB_HOST=ratticdb-postgres' \
  -e 'DB_PORT=5432' \
  -e 'DB_USER=ratticdb' \
  -e 'DB_PASSWORD=changeme' \
  -e 'DB_NAME=ratticdb' \
  -e 'TIMEZONE=UTC' \
  -e 'VIRTUAL_HOST=somedomain.example.com' \
  -e 'SECRETKEY=someverysecretkeyforsessions' \
  -e 'MAIL_HOST=smtp.example.com' \
  -e 'MAIL_PORT=587' \
  -e 'MAIL_USER=example@example.com' \
  -e 'MAIL_PASSWORD=someemailpassword' \
  -e 'MAIL_FROM=emailed-from@example.com' \
  -e 'MAIL_ENABLE_TLS=true' \
  $USER/ratticdb:1.3.1
```


