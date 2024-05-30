# Use Ubuntu base image
FROM ubuntu:latest

RUN apt-get update && apt-get install -y python3-pip git


RUN useradd -m -s /bin/bash devuser
WORKDIR /home/devuser

USER devuser

ENTRYPOINT ["/bin/bash"]