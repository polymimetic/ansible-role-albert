#! /usr/bin/env bash
set -e
###########################################################################
#
# Albert Bootstrap Installer
# https://github.com/polymimetic/ansible-role-albert
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/ansible-role-albert/master/install.sh | bash
#
###########################################################################

if [ `id -u` = 0 ]; then
  printf "\033[1;31mThis script must NOT be run as root\033[0m\n" 1>&2
  exit 1
fi

###########################################################################
# Constants and Global Variables
###########################################################################

readonly GIT_REPO="https://github.com/polymimetic/ansible-role-albert.git"
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/ansible-role-albert/master"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_error()   { echo -e "\033[1;31m✖  $@\033[0m";     }      # red
function e_success() { echo -e "\033[1;32m✔  $@\033[0m";     }      # green
function e_info()    { echo -e "\033[1;34m$@\033[0m";        }      # blue
function e_title()   { echo -e "\033[1;35m$@.......\033[0m"; }      # magenta

###########################################################################
# Install Albert
# https://albertlauncher.github.io/
#
# https://albertlauncher.github.io/docs/installing/
###########################################################################

install_albert() {
  e_title "Installing Albert"

  local albert_files="${SCRIPT_PATH}/files/albert"

  # Add Albert PPA
  if ! grep -q "nilarimogard/webupd8" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:nilarimogard/webupd8
    sudo apt-get update
  fi

  # Install albert
  sudo apt-get install -yq albert

  # Create startup application directory
  if [[ ! -d "${HOME}/.config/autostart" ]]; then
    mkdir -p "${HOME}/.config/autostart"
  fi

  # Add new albert startup entry
  cp "${albert_files}/albert.desktop" "${HOME}/.config/autostart"

  # Create albert icons directory
  if [[ ! -d "${HOME}/.config/albert/icons" ]]; then
    mkdir -p "${HOME}/.config/albert/icons"
  fi
  cp -a "${albert_files}/icons/." "${HOME}/.config/albert/icons"

  # Albert Websearch JSON
  cp "${albert_files}/org.albert.extension.websearch.json" "${HOME}/.config/albert"
  sed -i "s/{{ USER }}/${USER}/" ${HOME}/.config/albert/org.albert.extension.websearch.json

  # Albert configuration
  cp "${albert_files}/albert.conf" "${HOME}/.config"

  e_success "Albert installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_albert
}

program_start