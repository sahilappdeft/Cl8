# just files are like makefiles but a bit
# more intuitive to use
# https://github.com/casey/just


@test *options:
    venv/Scripts/activate

@install:
    #!/usr/bin/env bash

    python -m venv venv
    venv\Scripts\pip install -r requirements.txt  
    cd theme/static_src/ && npm install && cd ../..
    python manage.py migrate
    python manage.py collectstatic --no-input

@ci:
    pytest

@fetch-files-from-s3:
    bash ./scripts/fetch_media_file_from_s3.sh

@serve *options:
    python manage.py runserver {{options}}

@manage *options:
    python manage.py {{options}}

@tailwind-dev:
    python manage.py tailwind start

@tailwind-build:
    python manage.py tailwind build

@run *options:
    # run gunicorn in production
    gunicorn config.wsgi --bind :8000 --workers 2 {{options}}
    # pipenv run gunicorn config.wsgi -b :9000 --timeout 300 {{options}}

@docker-build:
    # create a docker image, tagged as cl8
    docker build . -t cl8

@docker-run:
    # run the current local docker image tagged as cl8, using the env file at .env
    docker run --env-file .env -p 8000:8000 -p 5432:5432 cl8

@caddy:
    caddy run