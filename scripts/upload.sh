#!/bin/bash

# How to use: 
#  - set up the aws cli for whatever system (requires python and pip)
#  - run `aws configure --profile upload` and give it the right iam keys
#  - 

if [ $# -ne 1 ]; then
    echo 'usage: upload <directory>'
    exit 1
fi

directory=$1
aws --profile upload s3 sync --exclude .DS_Store $directory s3://ewenberg-blog-images/$directory
aws --profile upload s3 sync --exclude .DS_Store s3://ewenberg-blog-images/$directory $directory

