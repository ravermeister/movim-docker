#!/usr/bin/env bash

movim_daemon() {
	cd /usr/local/share/movim
	composer movim:migrate \
		&& php daemon.php start
}

system_services() {
	service "$(basename "$(find /etc/init.d -type f -name "php*-fpm")")" start
	service nginx start
}

if [ "$(id -u)" -eq 0 ]; then
	system_services
	su -l www-data -s /bin/bash "$0"
else
	movim_daemon
fi
