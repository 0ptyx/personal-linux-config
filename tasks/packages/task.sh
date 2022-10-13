#!/bin/bash
#


# Get packags from file
# $1 = return variable
# $2 = path to package file
get_packages() {
    local all_pkgs=""
    while read -r pkg 
    do
        all_pkgs+=" $pkg"
    done < "$2"
    eval "$1='$all_pkgs'"
}

# run Apt 
# $1 = package list
do_apt() {
    debian_pkgs="" 
    if [[ -f "$(pwd)/tasks/packages/deb.pkgs" ]];
    then
        get_packages debian_pkgs "$(pwd)/tasks/packages/deb.pkgs"
    fi
    sudo apt update && sudo apt upgrade -y
    cmd="sudo apt-get install -y"
    cmd+=$1
    cmd+=$debian_pkgs
    echo $cmd
    eval $cmd
}


post_arch() {
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
}

# run pacman
# $1 = package list
do_pacman() {
    arch_pkgs="" 
    if [[ -f "$(pwd)/tasks/packages/arch.pkgs" ]];
    then
        get_packages arch_pkgs "$(pwd)/tasks/packages/arch.pkgs"
    fi
    sudo pacman -Syyuu
    cmd="sudo pacman --noconfirm -Sy"
    cmd+=$1
    cmd+=$arch_pkgs
    eval $cmd
}
# Get agnostic pkgs
get_packages base_pkgs "$(pwd)/tasks/packages/packages"
if command -v apt > /dev/null
then
    do_apt "$base_pkgs"
elif command -v pacman > /dev/null
then
    do_pacman "$base_pkgs"
fi

 





