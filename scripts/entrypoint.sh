set -e

python='/usr/bin/python2.7'
uwsgi='/usr/local/bin/uwsgi'

envtpl -o /srv/rattic/conf/local.cfg /usr/local/etc/rattic/local.cfg.j2

if [[ "$1" == 'migrate' ]]; then
  sleep 10
  $python manage.py migrate --all
fi

if [[ "$1" == 'init' ]]; then
  sleep 10
  $python manage.py syncdb --noinput
  $python manage.py demosetup
fi

$python manage.py collectstatic --noinput
$python manage.py compilemessages

if [[ "$1" != 'init' ]]; then
	# Tweak nginx to match the workers to cpu's
	procs=$(cat /proc/cpuinfo |grep processor | wc -l)
	sed -i -e "s/worker_processes 5/worker_processes $procs/" /etc/nginx/nginx.conf

	# Start supervisord and services
	/usr/bin/supervisord -n -c /etc/supervisord.conf
fi

set +e
