FROM ubuntu:latest
WORKDIR /bogu
COPY build .
RUN ls build
# EXPOSE 8080
ENTRYPOINT [ "/bogu/build/bin/bogu" ]
CMD [ "-v" ]
