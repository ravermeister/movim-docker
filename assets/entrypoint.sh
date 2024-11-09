#!/usr/bin/env bash

composer movim:migrate \
	&& php daemon.php start