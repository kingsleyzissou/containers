# We want to be able to use the same container file to build
# both centos & fedora containers. To get around this we can
# tag the images as base-image depending on which image we
# would like to build, i.e.:
# podman tag quay.io/toolbx-images/centos-toolbox:stream9 base-image
# podman tag quay.io/fedora/fedora-toolbox:41 base-image
FROM base-image

##########################################################
##### build args
##########################################################
ARG COCKPIT_PORT
ARG COCKPIT_CONFFILE=/etc/systemd/system/cockpit.socket.d/listen.conf

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
  'dnf-command(config-manager)' \
  fastfetch \
  fzf \
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

# we have to download this rather than use the config-manager since
# fedora uses dnf5 and cs9 uses dnf4
RUN curl -o /etc/yum.repos.d/gh-cli.repo https://cli.github.com/packages/rpm/gh-cli.repo
RUN dnf install -y gh --repo gh-cli

##########################################################
##### projects
##########################################################
RUN dnf install -y \
  cockpit \
  osbuild \
  osbuild-composer

##########################################################
##### openscap
##########################################################
RUN dnf install -y \
  openscap-scanner \
  openscap-utils \
  scap-security-guide

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
RUN echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/wheel-nopassword

##########################################################
##### cockpit port
##########################################################
# since we have multiple containers, we don't want the
# cockpit ports to conflict, set these via a build arg
RUN mkdir -p $(dirname $COCKPIT_CONFFILE)
RUN echo "[Socket]" >> $COCKPIT_CONFFILE
RUN echo "ListenStream=" >> $COCKPIT_CONFFILE
RUN echo "ListenStream=$COCKPIT_PORT" >> $COCKPIT_CONFFILE
RUN systemctl enable cockpit.socket
