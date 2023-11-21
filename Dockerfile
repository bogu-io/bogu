FROM ubuntu:latest
WORKDIR /bogu
COPY build .
# EXPOSE 8080
ENTRYPOINT [ "build/bin/bogu" ]
CMD [ "-v" ]
