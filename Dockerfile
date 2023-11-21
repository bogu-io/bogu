FROM ubuntu:latest
WORKDIR /bogu
COPY build .
# EXPOSE 8080
ENTRYPOINT [ "/bogu/bin/bogu" ]
CMD [ "-v" ]
