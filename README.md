# uwsgi_flask_tf
#TensorflowServing #uWSGI #Flask #AI #Docker #Container #Sample

# requirements software
```
1) docker enginee
2) docker-compose
3) python3
4) jupyter notebook (python package)
```

# uWSGI+Flask+Tensorflow2.2.0 sample
## Build docker image
```
$ cd docker
$ sh build_image.sh
```

## Build docker image
```
$ cd docker
$ docker-compose up
```

# Tensorflow serving sample
## Get Tensorflow serving image
```
$ docker pull tensorflow/serving:2.2.0
```

## Build docker image
```
$ cd docker
$ docker-compose -f docker-compose.serving.yml
```