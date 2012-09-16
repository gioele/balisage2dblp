#!/bin/sh

mkdir -p "balisage"

for num in `seq 1 20` ; do
	toc="http://www.balisage.net/Proceedings/vol${num}/contents.html"
	wget -c ${toc} -O "balisage/balisage-vol${num}.html"

	[ $? -ne 0 ] && echo "Balisage volume ${num} not found, stopping here" && break
done
