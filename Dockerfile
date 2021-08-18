# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.191.0/containers/go/.devcontainer/base.Dockerfile


################################## BASE IMAGE #####################################

# [Choice] Go version: 1, 1.16, 1.15
ARG VARIANT=$VARIANT

# FROM mcr.microsoft.com/vscode/devcontainers/go:0-$VARIANT
FROM golang:${VARIANT} as base

# [Choice] Node.js version: none, lts, 16, 14, 12, 10
# ARG NODE_VERSION=$NODE_VERSION
# RUN if [ "${NODE_VERSION}" = "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

ARG UID=1000
ARG GID=1000
ARG USER="golang"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    sudo \
    # && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
  && sudo apt-get clean \
  && sudo rm -rf /var/cache/apt/archives/* \
  && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && sudo truncate -s 0 /var/log/*log

# Configure non-root user based on https://hint.io/blog/rails-development-with-docker
RUN groupadd -g $GID $USER && \
useradd -u $UID -g $USER -m $USER && \
usermod -p "*" $USER && \
usermod -aG sudo $USER && \
echo "$USER ALL=NOPASSWD: ALL" >> /etc/sudoers.d/50-$USER

# USER $USER
    
COPY --chown=$USER ./gotools.sh .

RUN chmod +x ./gotools.sh && sudo bash ./gotools.sh

############################## DEVCONTAINER IMAGE #################################

FROM base as devcontainer

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    software-properties-common \
  && sudo apt-get clean \
  && sudo rm -rf /var/cache/apt/archives/* \
  && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && sudo truncate -s 0 /var/log/*log

USER $USER

# Install Git Cli
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C99B11DEB97541F0 \ 
&& sudo apt-add-repository https://cli.github.com/packages \
&& sudo apt update -qq \
&& sudo apt install -y gh

# Install zsh and vim
RUN sudo apt install -y zsh imagemagick jq vim \
&& sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# [Optional] Uncomment the next line to use go get to install anything else you need
# RUN go get -x <your-dependency-or-tool>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

