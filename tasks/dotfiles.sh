#!/bin/bash
#
DOT_DIR=$HOME/.dotfiles
git clone https://github.com/0ptyx/.dotfiles.git $DOT_DIR
for dir in $DOT_DIR/*
do
    if [[ -d "$DOT_DIR/$dir" ]];
    then
        stow -d $DOT_DIR/$DIR
    fi
done


