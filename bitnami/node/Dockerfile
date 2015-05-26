FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV BITNAMI_APP_NAME nodejsstandalone
ENV BITNAMI_APP_VERSION 0.12.2-0
ENV BITNAMI_APP_DIRNAME nodejs

ADD https://storage.googleapis.com/bitnami-artifacts/install.sh?GoogleAccessId=432889337695-e1gggo94k5qubupjsb35tajs91bdu0hg@developer.gserviceaccount.com&Expires=1434934078&Signature=QNkAu%2F8E2RlalSQy4n1sxMhsGKF%2FVltr6zu65HU6A9H0HKOgl6u9etqy9w6OwD4DsLMxYuy2uymOK3iDc5RbfkAMncKI1zJpxcwRQ4Mt43Oe8PBXKbQYcZ7mQaYPtpnjYblDs1S2p12Pu5NTDJHK2hJ1MrIUYwBup5n60R6OJRI%3D /tmp/install.sh

RUN sh /tmp/install.sh

ENV PATH /opt/bitnami/python/bin:/opt/bitnami/nodejs/bin:/opt/bitnami/common/bin:$PATH

EXPOSE 80
VOLUME ["/app"]
WORKDIR /app

CMD ["node"]
