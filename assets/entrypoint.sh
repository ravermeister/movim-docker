#!/usr/bin/env bash

export MOVIM_MAIN_URL=${MOVIM_MAIN_URL:-https://localhost}

init_config() {	
	for conf in $(find /etc/nginx/tpl-enabled -name "*.conf"); do 
		filename=$(basename "$conf")
		envsubst < "$conf" > "/etc/nginx/conf-enabled/$filename"
	done
}

movim_daemon() {
	php "$(which composer)" movim:migrate
	php daemon.php start
}

system_services() {
	service "$(basename "$(find /etc/init.d -type f -name "php*-fpm")")" start
	service nginx start
}

update_volume_permissions() {
	chown -R www-data:www-data /usr/local/share/galene
	chown -R www-data:www-data /usr/local/share/movim/cache
	chown -R www-data:www-data /usr/local/share/movim/public/cache
	chown -R www-data:www-data /usr/local/share/movim/log
}

## Main execution

if [ "$(id -u)" -eq 0 ]; then
	init_config
	system_services
	update_volume_permissions
	su -l www-data -s /bin/bash "$0"
else
  cd /usr/local/share/movim || exit 1
	movim_daemon
fi
