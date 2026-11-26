FROM ruby:3.3-slim

# Install build dependencies, git, Node.js, and gosu for privilege dropping
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    gosu \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Pre-install Jekyll, Bundler, and the Chirpy theme gem
RUN gem install --no-document jekyll bundler jekyll-theme-chirpy

# Clone the official Chirpy starter template and pre-install its dependencies
RUN git clone --depth 1 https://github.com/cotes2020/jekyll-theme-chirpy /opt/chirpy-starter \
    && rm -rf /opt/chirpy-starter/.git \
    && cd /opt/chirpy-starter \
    && bundle install

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /srv/jekyll

EXPOSE 4000 35729

ENTRYPOINT ["entrypoint.sh"]
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--livereload", "--force_polling"]
