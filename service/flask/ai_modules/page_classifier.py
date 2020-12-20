import os
import sys
import numpy
import cv2
import logging
from PIL import Image
from threading import Lock
# from keras.models import load_model
import tensorflow as tf

sys.path.append(os.path.join(os.path.dirname(__file__), '.'))
from ai_modules.predict_config import CLASSIFIER_H5_FILE

class PageClassifier():
    def __init__(self):

        ## init model
        self._model = tf.keras.models.load_model(
            os.path.expanduser(CLASSIFIER_H5_FILE), compile=False)

        ## init Lock
        self._lock = Lock()

    def predict_batch(self, input_array):

        ## lock
        self._lock.acquire()

        ## predict
        try:
            metrix = self._model.predict(input_array)
        finally:
            self._lock.release()

        ## to one hot metrix
        results = []        
        rslt_type = numpy.where(metrix[0][0] == numpy.amax(metrix[0][0]))
        rslt_rot = numpy.where(metrix[1][0] == numpy.amax(metrix[1][0]))

        for idx in range(len(rslt_type)):
            type_idx = int(rslt_type[idx]) # 0 ~ ...
            rot_idx = int(rslt_rot[idx]) # 0 ~ 3
            results.append({'type_idx' : type_idx, 'rot_idx' : rot_idx})
        
        return results

