FROM debian:buster

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y apt-utils python3-pip python3 libsm6 libxext6 libxrender-dev && \
    apt-get install -y fonts-ipafont fonts-takao && \
    apt-get install -y ghostscript && \
    apt-get autoclean && \
    apt-get clean && \
    mkdir -p /app/code/flask /app/code/predict /app/data/models /app/data/uploads /var/log/uwsgi

WORKDIR /app/code

COPY . .

RUN mkdir -p ~/.pip/ && \
    mv ./pip.conf ~/.pip/ && \
    pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt && \
    rm -rf /app/code/Dockerfile 

ENV FLASK_APP=/app/code/index.py \
    FLASK_RUN_PORT=9002 \
    FLASK_DEBUG=0

EXPOSE 9002

WORKDIR /app/code/flask
CMD ["flask", "run"]
