#!/bin/bash

cd /home/ubuntu/KDIL-201

git clone https://github.com/duncdeane/my-kongair.git

cd /home/ubuntu/KDIL-201/my-kongair

git branch --all

git checkout development/flights

git checkout -b task/add-custom-headers


git branch --all