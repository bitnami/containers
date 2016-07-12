FROM gcr.io/stacksmith-images/ubuntu-buildpack:14.04-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=2.3.1-r1 \
    BITNAMI_APP_NAME=ruby

RUN bitnami-pkg install ruby-2.3.1-1 --checksum a81395976c85e8b7c8da3c1db6385d0e909bd05d9a3c1527f8fa36b8eb093d84
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/sqlite/bin:/opt/bitnami/common/bin:$PATH

RUN bitnami-pkg install imagemagick-6.7.5-10-3 --checksum 617e85a42c80f58c568f9bc7337e24c03e35cf4c7c22640407a7e1e16880cf88
RUN bitnami-pkg install mysql-libraries-10.1.13-0 --checksum 71ca428b619901123493503f8a99ccfa588e5afddd26e0d503a32cca1bc2a389

CMD ["irb"]

WORKDIR /app

EXPOSE 3000
