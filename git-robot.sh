#!/bin/bash

git clone https://github.com/pallets/flask.git
cd flask
git log --pretty=format:"%H %s" | grep -v -i 'flask' > ../bot.log
used=`cat ../bot.used | tail -n 1`
if [ -n "${used}" ]; then
    echo "last used commit id is : ${used}"
    sed -i '/'"${used}"'/,$d' ../bot.log
fi
# 随机倒数第几个,3中随机
RN=$[RANDOM%3+1]
cert_git_id=`cat ../bot.log | tail -n $RN|head -n 1 | awk '{print $1}'`
cert_git_info=`cat ../bot.log | grep "${cert_git_id}" |awk -F "${cert_git_id} " '{print$2}'`
echo "choice commit: ${cert_git_id}"
echo "commit info  :${cert_git_info}"
echo "reset to commit"
git reset --hard ${cert_git_id}
echo "rsync"
rsync -arv --exclude=".git" --exclude="README.rst"  --exclude="README.md"  ./ ../
cd ..
echo "delete remote git"
rm -rf flask
rm -rf src/flask
mv src/flask src/roby
mv flask.py roby.py
echo ${cert_git_id} >> bot.used
echo "git add ."
git add *
echo "commit and push"
git commit -m "${cert_git_info}"
git push -u origin
