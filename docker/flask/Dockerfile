FROM debian:buster

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y apt-utils python3-pip python3 libsm6 libxext6 libxrender-dev libgl1-mesa-glx mecab && \
    apt-get install -y fonts-ipafont fonts-takao mecab-ipadic-utf8 mecab-ipadic && \
    apt-get install -y ghostscript && \
    apt-get autoclean && \
    apt-get clean && \
    mkdir -p /app/code/flask /app/code/predict /app/data/models /app/data/uploads /var/log/uwsgi

WORKDIR /app/code

COPY . .

RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt && \
    rm -rf /app/code/Dockerfile && \
    ln -s /usr/lib/x86_64-linux-gnu/libmecab.so.2.0.0 /usr/lib/x86_64-linux-gnu/libmecab.so

ENV MECAB_PATH=/usr/lib/x86_64-linux-gnu/libmecab.so \
    FLASK_APP=/app/code/index.py \
    FLASK_RUN_PORT=9002 \
    FLASK_DEBUG=0

EXPOSE 9002

WORKDIR /app/code/flask
CMD ["flask", "run"]
