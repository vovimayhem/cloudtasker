FROM ruby:2.7.1 AS build-base

# Consider adding packages that are required for building the library at CI only.
# Add any developer tools in the "development" stage instead.

FROM build-base AS development

RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    apt-utils \
    build-essential \
    git \
    openssh-client \
    less \
    iproute2 \
    procps \
    curl \
    wget \
    unzip \
    nano \
    jq \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    dialog \
    gnupg2 \
    libc6 \
    libgcc1 \
    libgssapi-krb5-2 \
    libicu[0-9][0-9] \
    liblttng-ust0 \
    libssl1.1 \
    libstdc++6 \
    zlib1g \
    locales \
    sudo \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/*

# https://dl.equinox.io/ngrok/ngrok/stable/archive
RUN export NGROK_VERSION=2.3.35 \
 && export NGROK_SHA256=55df9c479b41a3b9b488458b5fb758df63001d14196a4126e3f669542c8727e9 \
 && curl -o /tmp/ngrok.tar.gz "https://bin.equinox.io/a/jAq5uX8wfS8/ngrok-${NGROK_VERSION}-linux-amd64.tar.gz" \
 && echo "${NGROK_SHA256}  /tmp/ngrok.tar.gz" | sha256sum -c - \
 && tar xvf /tmp/ngrok.tar.gz -C /usr/local/bin/ \
 && rm -rf /tmp/ngrok.tar.gz

# Add Node & Yarn from the official node image:
COPY --from=node:lts-buster-slim /usr/local/include/node /usr/local/include/node
COPY --from=node:lts-buster-slim /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node:lts-buster-slim /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/
COPY --from=node:lts-buster-slim /usr/local/share/doc/node /usr/local/share/doc/node
COPY --from=node:lts-buster-slim /usr/local/share/man/man1/node.1 /usr/local/share/man/man1/node.1
COPY --from=node:lts-buster-slim /usr/local/share/systemtap/tapset/node.stp /usr/local/share/systemtap/tapset/node.stp
COPY --from=node:lts-buster-slim /opt/yarn-v* /opt/yarn
RUN rm -rf /usr/local/bin/np* \
 && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
 && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npx \
 && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
 && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
 && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg