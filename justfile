@test *options:
    . venv/bin/activate && pytest {{options}}

@install:
    #!/usr/bin/env sh
    
    python3 -m venv venv
    source venv/bin/activate && pip install -r requirements.txt
    cd theme/static_src/ && npm install && cd ../..
    source venv/bin/activate && ./manage.py migrate
    source venv/bin/activate && ./manage.py collectstatic --no-input

@ci:    
    source venv/bin/activate && pytest

@fetch-files-from-s3:
    source venv/bin/activate && bash ./scripts/fetch_media_file_from_s3.sh

@serve *options:
    source venv/bin/activate && ./manage.py runserver {{options}}

@manage *options:
    source venv/bin/activate && ./manage.py {{options}}

@tailwind-dev:
    source venv/bin/activate && ./manage.py tailwind start

@tailwind-build:
    source venv/bin/activate && ./manage.py tailwind build

@run *options:
    # run gunicorn in production
    source venv/bin/activate && gunicorn config.wsgi --bind :8000 --workers 2 {{options}}
    # . venv/bin/activate && gunicorn config.wsgi -b :9000 --timeout 300 {{options}}

@docker-build:
    # create a docker image, tagged as cl8
    docker build . -t cl8

@docker-run:
    # run the current local docker image tagged as cl8, using the env file at .env
    docker run --env-file .env -p 8000:8000 -p 5432:5432 cl8

@caddy:
    caddy run
