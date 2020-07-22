#!/bin/bash

source /etc/profile
tag=`cat ../tag_list | head -n 1`
git tag -a "${tag}" -m "Release :${tag}"
git push origin --tags
sed -i '/'"${tag}"'/d' ../tag_list
