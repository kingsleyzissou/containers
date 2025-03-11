FROM registry.fedoraproject.org/fedora-toolbox:latest

##########################################################
##### langauges
##########################################################
RUN dnf install -y \
  golang \
  nodejs

##########################################################
##### tools
##########################################################
RUN dnf copr -y enable atim/starship
RUN dnf copr -y enable atim/lazygit
RUN dnf install -y \
  bat \
  fastfetch \
  fzf \
  gh \
  git \
  git-delta \
  jq \
  lazygit \
  luarocks \
  neovim \
  ripgrep \
  starship \
  stow \
  zoxide \
  zsh
RUN dnf copr -y disable atim/starship
RUN dnf copr -y disable atim/lazygit

##########################################################
##### projects
##########################################################
RUN dnf install -y \
  cockpit \
  osbuild \
  osbuild-composer

##########################################################
##### project dependencies
##########################################################
RUN dnf install -y \
  btrfs-progs-devel \
  device-mapper-devel \
  gpgme-devel \
  libassuan-devel \
  krb5-devel \
  rpmdevtools \
  rpmlint

##########################################################
##### cleanup
##########################################################
RUN dnf clean all

##########################################################
##### wheel no password
##########################################################
COPY wheel-nopassword /etc/sudoers.d/.
