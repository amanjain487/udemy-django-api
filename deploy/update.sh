#!/usr/bin/env bash

set -e

PROJECT_BASE_PATH='/usr/local/apps/udemy-django-api'

git pull
$PROJECT_BASE_PATH/profiles_api/bin/python manage.py migrate
$PROJECT_BASE_PATH/profiles_api/bin/python manage.py collectstatic --noinput
supervisorctl restart profiles_api

echo "DONE! :)"
