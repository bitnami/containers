FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV BITNAMI_PREFIX /usr/local/bitnami
ENV BITNAMI_APP_NAME nodejsstandalone
ENV BITNAMI_APP_VERSION 0.12.4-0
ENV BITNAMI_APP_DIR $BITNAMI_PREFIX/nodejs
ENV BITNAMI_APP_USER bitnami

ADD https://www.dropbox.com/s/kce54xvd1jmka3h/bitnami-utils.sh?dl=1 /bitnami-utils.sh
ADD https://storage.googleapis.com/bitnami-artifacts/install.sh?GoogleAccessId=432889337695-e1gggo94k5qubupjsb35tajs91bdu0hg@developer.gserviceaccount.com&Expires=1434934078&Signature=QNkAu%2F8E2RlalSQy4n1sxMhsGKF%2FVltr6zu65HU6A9H0HKOgl6u9etqy9w6OwD4DsLMxYuy2uymOK3iDc5RbfkAMncKI1zJpxcwRQ4Mt43Oe8PBXKbQYcZ7mQaYPtpnjYblDs1S2p12Pu5NTDJHK2hJ1MrIUYwBup5n60R6OJRI%3D /tmp/install.sh
ADD post-install.sh /tmp/post-install.sh
RUN sh /tmp/install.sh

ENV PATH $BITNAMI_PREFIX/python/bin:$BITNAMI_PREFIX/nodejs/bin:$BITNAMI_PREFIX/common/bin:$PATH
USER $BITNAMI_APP_USER

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80
VOLUME ["/app"]
WORKDIR /app

CMD ["node"]
