#!/bin/bash
#


# Get packages from file 
# $1 : Return variable
# $2 : path to package file
get_packages() {
    local all_pkgs=""
    while read -r pkg 
    do
        all_pkgs+=" $pkg"
    done < "$2"
    # TODO/NOTE: This is sort of a hack?
    # Without this, eval will attempt to execute
    # each package as a command which is not what 
    # we want. Might want to look for a better way 
    # to pass things back without using globals
    eval "$1='$(echo $all_pkgs)'"
}

# install packages provided by $1 with apt
do_apt() {
    sudo apt update && sudo apt upgrade -y
    cmd="sudo apt-get install -y"
    cmd+=$1
    eval $cmd
}

post_arch {
    git clone https//aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm --needed
    yay -S && yay -Sy --noconfirm --needed stow
}

# install packages provided by $1 with pacman
do_pacman() {
    sudo pacman -Syyuu --noconfirm
    cmd="sudo pacman --needed --noconfirm -Sy"
    cmd+=$1
    eval $cmd
}

get_packages pkgs "$(pwd)/tasks/packages/packages"

if command -v apt > /dev/null
then
    # get debian specific packages
    deb_pkgs=""
    if [[ -f "$(pwd)/tasks/packages/deb.pkgs" ]]
    then
        get_packages deb_pkgs "$(pwd)/tasks/packages/deb.pkgs"
    fi
    $pkgs+=$deb_pkgs
    do_apt "$pkgs"
elif command -v pacman > /dev/null
then
    # get arch specific packages 
    arch_pkgs=""
    if [[ -f "$(pwd)/tasks/packages/arch.pkgs" ]]
    then
        get_packages arch_pkgs "$(pwd)/tasks/packages/arch.pkgs"
    fi
    $pkgs+=$arch_pkgs
    do_pacman "$pkgs" && post_arch
fi

 





