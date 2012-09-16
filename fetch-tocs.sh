#!/bin/sh

mkdir -p "balisage"

for num in `seq 1 9` ; do
	toc="http://www.balisage.net/Proceedings/vol${num}/contents.html"
	wget -c ${toc} -O "balisage/balisage-vol${num}.html"
done
