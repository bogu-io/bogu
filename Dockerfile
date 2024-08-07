FROM ubuntu:latest
WORKDIR /bogu
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://github.com/bogu-io/bogu/releases/download/0.0.17/bogu-0.0.17-linux-x64.zip \
    && unzip bogu-0.0.17-linux-x64.zip
# EXPOSE 8080
ENTRYPOINT [ "bogu-0.0.17/bin/bogu" ]
CMD [ "--version" ]
