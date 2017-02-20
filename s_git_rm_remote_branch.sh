#! /bin/bash
remote=$1
branch=$2
if [ $# = 2 ]; then
    git push $remote :$branch
else
    echo "git push remote :branch"
fi
