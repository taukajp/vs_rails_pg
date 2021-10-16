# [Choice] Ruby version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.1, 3.0, 2, 2.7, 2.6, 3-bullseye, 3.1-bullseye, 3.0-bullseye, 2-bullseye, 2.7-bullseye, 2.6-bullseye, 3-buster, 3.1-buster, 3.0-buster, 2-buster, 2.7-buster, 2.6-buster
ARG VARIANT="3-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/ruby:0-${VARIANT}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
# The value is a comma-separated list of allowed domains
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] Uncomment this section to install additional OS packages.
ARG PG_CL_VERSION="13"
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    # Install packages
    sqlite3 libsqlite3-dev \
    postgresql-client-${PG_CL_VERSION} \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# [Optional] Uncomment this line to install additional gems.
# RUN gem install <your-gem-names-here>

ENV APP_NAME="myapp"
RUN mkdir /${APP_NAME}
WORKDIR /${APP_NAME}
COPY Gemfile Gemfile.lock ./

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_APP_CONFIG=.bundle \
    BUNDLE_PATH=vendor/bundle
RUN gem update --system && bundle install
COPY . ./

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
