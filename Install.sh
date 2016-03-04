#!/bin/sh

skipthese=(./LICENSE ./Install.sh ./vimrc ./Makefile)

if ! cmp -s $HOME/.vimrc vimrc ; then
  echo updating .vimrc
  if [[ $1 == "diff" ]] ; then
    diff $HOME/.vimrc vimrc
  fi
  if [[ $1 == "commit" ]] ; then
    echo -- $HOME/.vimrc vimrc
  fi
fi

for file in $(find . -type f);
do 
  toskip=0
  for skip in ${skipthese[@]}; do
    if [[ $file == ./.* ]] || [[ $file == $skip ]] ; then
      toskip=1
    fi  
  done

  if [ $toskip == 1 ]; then
    continue
  fi

  if [ -f $HOME/.vim/$file ] ; then
    if ! cmp -s $HOME/.vim/$file $file ; then
      echo updating $file
      if [[ $1 == "diff" ]] ; then
        diff $HOME/.vim/$file $file 
      fi
      if [[ $1 == "commit" ]] ; then
        echo -- $file $HOME/.vim/$file
      fi
    fi
  else
    echo install $file
    if [[ $1 == "commit" ]] ; then
      echo -- $file $HOME/.vim/$file
    fi
  fi
done   
