# Quick reference

-	**Where to get help**:
	the Movim XMPP MUC - movim@conference.movim.eu

-	**Where to file issues**:
	[https://gitlab.rimkus.it/xmpp/movim-docker](https://gitlab.rimkus.it/xmpp/movim-docker/-/issues)

# What is Movim?

Movim is a distributed social network built on top of XMPP, a popular open standards communication protocol. Movim is a free and open source software licensed under the AGPL. It can be accessed using existing XMPP clients and Jabber accounts. Learn more at [movim.eu](https://movim.eu/).

> [wikipedia.org/wiki/Movim](https://en.wikipedia.org/wiki/Movim)

![logo](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Movim-logo.svg/354px-Movim-logo.svg.png)

# How to use this image

Note, this Image does *not* contain a required Database nor an XMPP Server. 
It is Based on Debian Slim and Consists of mainly:
- nginx (for the movim frontend)
- php-fpm (required for movim frontend and daemon)
- required php modules (e.g. imagick, zip)
- a little shell script for starting php-fpm, nginx and the movim daemon. 

## Prepare
Before running the Container, 
you have to copy (and rename to `.env`) and adjust the file [.env.example](assets/.env.example) from the assets' folder.
Add your DB Configuration and set the Correct Value for `DAEMON_URL` to point to your 
external URL for movim e.g., https://movim.example.org

## useful folders
the Following Files and Directories could be of interest:
- /etc/php/conf.d --> custom movim.ini
- /etc/php/pool.d --> custom movim fpm.conf
- /var/log/nginx --> nginx log
- /var/log/php8.2-fpm.log --> php-fpm log
- /usr/local/share/movim/log --> movim log


## Run
run the image as follows (movim will be available on host Machine at port 8080): 
```shell
docker run -d \
	--name movim \
	--restart always \	
	-p 8080:80 \	
	-v /path/to/.env:/usr/local/share/movim/.env
	ravermeister/movim-docker:latest
```

# Creating an Admin User

After you've successfully logged in to your Movim Pod, run the following Docker Compose exec command;

```
docker-compose exec movim php daemon.php setAdmin example@movim.eu
```
