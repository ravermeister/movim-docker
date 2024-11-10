#!/usr/bin/env bash

movim_daemon() {
	cd /usr/local/share/movim || exit 1
	composer movim:migrate \
		&& php daemon.php start
}

system_services() {
	service "$(basename "$(find /etc/init.d -type f -name "php*-fpm")")" start
	service nginx start
}

init_movim() {
	chown -R www-data:www-data /usr/local/share/movim/cache
	chown -R www-data:www-data /usr/local/share/movim/public/cache
}

if [ "$(id -u)" -eq 0 ]; then
	system_services
	init_movim
	su -l www-data -s /bin/bash "$0"
else
	movim_daemon
fi
