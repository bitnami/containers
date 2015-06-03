FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV BITNAMI_APP_NAME nginxstandalonestack
ENV BITNAMI_APP_VERSION 1.8.0-0
ENV BITNAMI_APP_DIRNAME nginx

ADD https://storage.googleapis.com/bitnami-artifacts/install.sh?GoogleAccessId=432889337695-e1gggo94k5qubupjsb35tajs91bdu0hg@developer.gserviceaccount.com&Expires=1434934078&Signature=QNkAu%2F8E2RlalSQy4n1sxMhsGKF%2FVltr6zu65HU6A9H0HKOgl6u9etqy9w6OwD4DsLMxYuy2uymOK3iDc5RbfkAMncKI1zJpxcwRQ4Mt43Oe8PBXKbQYcZ7mQaYPtpnjYblDs1S2p12Pu5NTDJHK2hJ1MrIUYwBup5n60R6OJRI%3D /tmp/install.sh
ADD post-install.sh /tmp/post-install.sh

RUN sh /tmp/install.sh

ADD vhosts/* /usr/local/bitnami/nginx/conf.defaults/vhosts/

ENV PATH /usr/local/bitnami/nginx/sbin:/usr/local/bitnami/common/bin:$PATH

EXPOSE 80 443
VOLUME ["/logs", "/conf", "/app"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
