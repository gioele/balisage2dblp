#!/bin/sh

# This is free software released into the public domain (CC0 license).

mkdir -p "balisage"

for num in `seq 1 20` ; do
	toc="http://balisage.net/Proceedings/vol${num}/contents.html"
	html="balisage/balisage-vol${num}.html"
	wget -c ${toc} -O $html

	[ $? -ne 0 ] && rm $html && echo "Balisage volume ${num} not found, stopping here" && break
done
