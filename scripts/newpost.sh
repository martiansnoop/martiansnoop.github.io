#!/bin/bash -e

if [ $# -ne 1 ]; then
    echo 'usage: newpost <title>'
    exit 1
fi

title=$1

timestamp=$(date '+%Y-%m-%d %H:%M:%S %z')
short_timestamp=${timestamp:0:10}

lowercase_title=$(echo $title | tr "[:upper:]" "[:lower:]")
normalized_title=${lowercase_title// /-}
post_file="_drafts/$short_timestamp-$normalized_title.md"
echo Creating file at $post_file

cat << EOF > $post_file
---
layout: post
title: $title
date: $timestamp
categories: 
---
EOF
