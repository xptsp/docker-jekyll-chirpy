# Docker Jekyll Chirpy

A Docker Compose setup for running a Jekyll site using the Chirpy theme. The container serves the site from the local `./site` directory and can initialize that directory with the default Chirpy starter files on first launch.

## Requirements

- Docker Engine
- Docker Compose v2 (`docker compose`)

## Quick start

From this project directory, run:

```sh
docker compose up -d
```

On first start, if `site/Gemfile` does not exist, the container copies the starter template into `site/` and installs the site's Ruby dependencies. Open [http://localhost:4000](http://localhost:4000) to view the site.

The Compose configuration publishes these ports:

- `4000`: Jekyll development server
- `35729`: LiveReload

The `site/` directory is mounted into the container, so edits are retained on the host and picked up by Jekyll. The container runs with `PUID=1000` and `PGID=1000` by default to help keep generated files owned by the matching host user. Change these values in `docker-compose.yaml` if your host user has different IDs.

## Working on the site

Edit the Jekyll files under `site/`. To stop the server, run:

```sh
docker compose down
```

To follow the container output:

```sh
docker compose logs -f jekyll
```

## Configuration

The Compose service uses the published `xptsp/jekyll-chirpy:latest` image, sets `JEKYLL_ENV=development`, and restarts unless stopped. The image's default command runs `bundle exec jekyll serve` on `0.0.0.0` with LiveReload and polling enabled.

The `Dockerfile` describes a locally built image. The Compose file currently references the published image rather than building that Dockerfile; to use a locally built image, build and tag it as `xptsp/jekyll-chirpy:latest` before running Compose:

```sh
docker build -t xptsp/jekyll-chirpy:latest .
docker compose up -d
```

