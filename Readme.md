# Informatik I - Python Docker Container

This container can be used in the course Informatik, TU Graz Austria [522318, 522319, GST376UF, GST377UF, SES129, SES130]. The GitHub repository contains a `Dockerfile` to automatically generate a Dockerimage on Dockerhub.

## Docker

To get started with Docker please see the official documentation at [https://www.docker.com/](https://www.docker.com/).

### Commands

Run the container and attach current path folder. If you want to remove authentication add the flag `--NotebookApp.token=''`

```bash
docker run -it -p 8888:8888 -v "$PWD":/root/informatik/ hannesoberreiter/tug-python362
```

## Working Directory

The working directory inside the container is set to `/root/informatik`.

## Python

For code reproducibility the container uses python `3.6.2` on Debian `stretch`.

## Juypter

In the container a `Juypter Notebook` `6.1.4` server is installed, which opens a port at `8888`. You can access the notebook at `http://127.0.0.1:8888/` or `http://localhost:8888/`.

## Libraries

All libraries with version number are found in `requirements.txt`. They are automatically installed with `pip3` when generating the docker container.
