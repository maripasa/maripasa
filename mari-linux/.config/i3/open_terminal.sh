#!/bin/zsh

if [ -f ~/.last_dir ]; then
	cd $(cat ~/.last_dir)
fi
exec $1
