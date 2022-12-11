#!/usr/bin/env bash

set -e

PROJECT_BASE_PATH='/usr/local/apps/udemy-django-api'

git pull

cd $PROJECT_BASE_PATH/
python manage.py migrate
python manage.py collectstatic --noinput

supervisorctl restart profiles_api

echo "DONE! :)"
