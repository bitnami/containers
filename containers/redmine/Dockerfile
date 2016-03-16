FROM gcr.io/stacksmith-images/ubuntu:14.04-r05

MAINTAINER Bitnami <containers@bitnami.com>

# Additional modules required
RUN IMAGEMAGICK_PACKAGE_SHA256="abed4e406b509206a834c104a750762c4fc7fd223a1a2231c7fd15320fb9734f" bitnami-pkg install imagemagick-6.7.5-10-0
RUN MYSQL_LIBRARIES_PACKAGE_SHA256="55cc1e7fd1bb56e34d9e9478963e30e39ad8728dcce58b39b5c40d24149f62f6" bitnami-pkg install mysql-libraries-10.1.11-0
RUN MYSQL_CLIENT_PACKAGE_SHA256="ac289d099bd00399805bd39ec243ec59b78f147ce3440a8c1f9b4012969ceaa8" bitnami-pkg install mysql-client-10.1.11-0
RUN BASE_FUNCTIONS_PACKAGE_SHA256="62cd7245831ad33910523132e0f423a37d37b1b5d1ce99cb2898bfc9ee799017" bitnami-pkg install base-functions-1.0.0-1

# Runtime
RUN RUBY_PACKAGE_SHA256="7e2ba51497ee7594f4dd080dcfcb8fcbe9a974fc7fea7bf8481b6998b959e058" bitnami-pkg install ruby-2.1.8-5
ENV PATH=/opt/bitnami/ruby/bin:$PATH

# Install application
ENV BITNAMI_APP_NAME=redmine \
    BITNAMI_APP_VERSION=3.2.1-1
RUN REDMINE_PACKAGE_SHA256="3ffcb9b86666f91af138f52e140325b974c2d631140cc687ae44f29e34442923" bitnami-pkg unpack $BITNAMI_APP_NAME-$BITNAMI_APP_VERSION

# Setting entry point
COPY rootfs /
ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "redmine"]
