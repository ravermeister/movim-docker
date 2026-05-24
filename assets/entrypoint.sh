#!/usr/bin/env bash

movim_migrate() {
  if [ -f "phinx.php" ]; then
    # fix for phinx.php missing CONFIG_PATH constant
      sed -i '2i\define("CONFIG_PATH", __DIR__ . "/config/");\nrequire_once __DIR__ . "/vendor/autoload.php";' \
        phinx.php
  fi
  php "$(which composer)" movim:migrate
}
movim_daemon() {
		php daemon.php start
}

system_services() {
	service "$(basename "$(find /etc/init.d -type f -name "php*-fpm")")" start
	service nginx start
}

update_volume_permissions() {
	chown -R www-data:www-data /usr/local/share/movim/cache
	chown -R www-data:www-data /usr/local/share/movim/public/cache
	chown -R www-data:www-data /usr/local/share/movim/log
}

## Main execution

if [ "$(id -u)" -eq 0 ]; then
	system_services
	update_volume_permissions
	su -l www-data -s /bin/bash "$0"
else
  cd /usr/local/share/movim || exit 1
  movim_migrate
	movim_daemon
fi
