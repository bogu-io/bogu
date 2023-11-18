FROM ubuntu:latest
WORKDIR /usr/local/bin
COPY bogu .
# EXPOSE 8080
ENTRYPOINT [ "bogu" ]
CMD [ "-v" ]
