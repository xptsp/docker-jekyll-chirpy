#!/bin/sh
set -e

PUID=${PUID:-1000}
PGID=${PGID:-1000}

# Create group and user matching host PUID/PGID if they don't already exist
if ! getent group "$PGID" >/dev/null 2>&1; then
    groupadd -g "$PGID" jekyll
fi
if ! getent passwd "$PUID" >/dev/null 2>&1; then
    useradd -u "$PUID" -g "$PGID" -m -s /bin/sh jekyll
fi

USER_NAME=$(getent passwd "$PUID" | cut -d: -f1)

# Initialize empty site directory if Gemfile is missing
if [ ! -f /srv/jekyll/Gemfile ]; then
    echo "Empty site directory detected. Initializing default Chirpy template..."
    cp -rn /opt/chirpy-starter/. /srv/jekyll/
fi

# Ensure the site directory and gem cache are writable by the target user
chown -R "$PUID:$PGID" /srv/jekyll /usr/local/bundle

# Install any new gems as the target user
gosu "$USER_NAME" sh -c "bundle check || bundle install"

# Drop root privileges and run the main command as the target user
exec gosu "$USER_NAME" "$@"
