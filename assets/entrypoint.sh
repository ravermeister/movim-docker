#!/usr/bin/env bash

movim_daemon() {
	composer movim:migrate \
		&& php daemon.php start
}

system_services() {
	service "$(basename "$(find /etc/init.d -type f -name "php*-fpm")")" start
	service nginx start
}

if [ "$(id -u)" -eq 0 ]; then
	system_services
	su -l movim "$0"
else
	movim_daemon
fi
