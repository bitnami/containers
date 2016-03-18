FROM gcr.io/stacksmith-images/ubuntu:14.04-r05

MAINTAINER Bitnami <containers@bitnami.com>

# Additional modules required
RUN IMAGEMAGICK_PACKAGE_SHA256="3048eedb9c183aa730561db406d4a85d198e7b070ed0cde6aa820e112ce329d1" bitnami-pkg install imagemagick-6.7.5-10-1
RUN MYSQL_LIBRARIES_PACKAGE_SHA256="de90c294a3319ab33f82d4af09d0f4942fcc831268344146b8347ce885d52c29" bitnami-pkg install mysql-libraries-10.1.11-1
RUN MYSQL_CLIENT_PACKAGE_SHA256="8dea362fbff8ac4cc0342d9e9b62c66498fd8be59ab2e106aefd085888b66b58" bitnami-pkg install mysql-client-10.1.11-1
RUN BASE_FUNCTIONS_PACKAGE_SHA256="ddd7aea91e039e07b571d5f4e589bedb5a1ae241e625f4a06a64a7ede439c7b8" bitnami-pkg install base-functions-1.0.0-1

# Runtime
RUN RUBY_PACKAGE_SHA256="174b666a3c98b30be17f60d85e873be7c194472d6a1c07ac43516d97223dca85" bitnami-pkg install ruby-2.1.8-6
ENV PATH=/opt/bitnami/ruby/bin:$PATH

# Install application
ENV BITNAMI_APP_NAME=redmine \
    BITNAMI_APP_VERSION=3.2.1-1
RUN REDMINE_PACKAGE_SHA256="c1faac8c6b30fc61f0a7486605395ef852cfce6e6cbdca7cdbdfb2bfe2476234" bitnami-pkg unpack $BITNAMI_APP_NAME-$BITNAMI_APP_VERSION

# Setting entry point
COPY rootfs /
ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "redmine"]
