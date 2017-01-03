FROM ubuntu:14.04

ENV RUBY_MAJOR="2.2" \
    RUBY_VERSION="2.2.2" \
    DB_PACKAGES="libsqlite3-dev" \
    RUBY_PACKAGES="ruby2.2 ruby2.2-dev" \
    BUNDLER_VERSION="1.10" \
    GEM_VERSION="2.0.14"

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_BIN="$GEM_HOME/bin" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential \
      curl \
      libffi-dev \
      libgdbm-dev \
      libncurses-dev \
      libreadline6-dev \
      libssl-dev \
      libyaml-dev \
      zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

RUN echo 'gem: --no-document' >> /.gemrc

RUN mkdir -p /tmp/ruby \
  && curl -L "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
      | tar -xjC /tmp/ruby --strip-components=1 \
  && cd /tmp/ruby \
  && ./configure --disable-install-doc \
  && make \
  && make install \
  && gem update --system \
  && rm -r /tmp/ruby

RUN gem update --system "$GEM_VERSION"
RUN gem install --no-document bundler --version "$BUNDLER_VERSION"

#this is needed until microservices and hercules are in parity in terms of ruby versions
#else this will unnecessarily need two jenkins or DwD build systems
RUN apt-get update && apt-get install -y openssh-server \
    && rm -rf /var/lib/apt/lists/* 

RUN echo "Host *\n\tStrictHostKeyChecking no\n\n" > /etc/ssh/ssh_config

# see http://guides.rubyonrails.org/command_line.html#rails-dbconsole
RUN apt-get update && apt-get install -y libmysqlclient-dev mysql-client postgresql-client libsqlite3-dev python-dev jq git --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN curl -O https://bootstrap.pypa.io/get-pip.py && python get-pip.py && pip install awscli

ENV TERM xterm
# Install nginx.
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update && apt-get install -y nginx && rm /etc/nginx/sites-available/default 
ADD nginx.conf /etc/nginx/nginx.conf

# Install foreman for handling nginx and unicorn under docker.
RUN gem install foreman

# Add lograte base template.
ADD unicorn_logrotate.conf /tmp/unicorn_logrotate.conf
ADD nginx_logrotate.conf /tmp/nginx_logrotate.conf
