## start with uwsgi-flask
export PYTHONUNBUFFERED="true" FLASK_DEBUG=0 USE_SIMULATOR=0 DATA_PATH=/app/data && uwsgi /app/code/flask/uwsgi.ini
