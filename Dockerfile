FROM ubuntu:latest
WORKDIR /usr/local/bin
COPY build/bin/bogu .
# EXPOSE 8080
ENTRYPOINT [ "bogu" ]
CMD [ "-v" ]
