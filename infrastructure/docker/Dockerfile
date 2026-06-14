FROM jenkins/jenkins:lts
USER root


RUN apt-get update && apt-get install -y \
    docker.io \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*


RUN pip3 install docker-compose --break-system-packages

RUN usermod -aG docker jenkins
USER jenkins