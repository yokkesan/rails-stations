FROM ruby:3.3.3

RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y \
    build-essential git libvips pkg-config nodejs npm \
    tzdata cron default-mysql-client && \
  ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata && \
  npm install -g n && n lts && \
  npm install -g yarn

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY . /app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]