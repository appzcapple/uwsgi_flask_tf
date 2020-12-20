import os
import json
import socket
import logging
import logging.handlers as handlers
from flask import Flask, request, jsonify
from flask import Flask
import numpy as np
from ai_modules.page_classifier import PageClassifier

ip_address = socket.gethostbyname(socket.gethostname())

logHandler = handlers.TimedRotatingFileHandler(f'../../logs/flask/flask.log', when='D', backupCount=60, interval=1)
logHandler.setLevel(logging.DEBUG)
logHandler.setFormatter(logging.Formatter(f'[%(asctime)s] [%(levelname)s] Flask - flask.server.ip:{ip_address} - %(pathname)s:%(lineno)d - %(message)s'))

logging.root.addHandler(logHandler)
logging.root.setLevel(logging.DEBUG)

logging.info('Flask starting.')
app = Flask(__name__)
if 'DATA_PATH' in os.environ and os.path.isdir(os.environ['DATA_PATH']):
    data_path = os.environ['DATA_PATH']
else:
    data_path = '../../data'

## init prediction module
page_cls = PageClassifier()
logging.info('Flask started.')

@app.route('/index')
def hellow_fun():
    return "<span style='color:red'>I am uwsgi app</span>"

@app.route('/prediction/classifier', methods=['POST'])
def prediction_classifier():

    ## Get json
    content = request.json
    images = content['instances']
    
    ## convert to np array
    image_array = np.asarray(images, dtype=np.float32)

    ## predict
    result_metrix = page_cls.predict_batch(image_array)

    return json.dumps(result_metrix)

if __name__ == "__main__":
    app.run('0.0.0.0')
