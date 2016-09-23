## BUILDING
##   (from project root directory)
##   $ docker build -t ruby-for-bitnami-bitnami-docker-ruby .
##
## RUNNING
##   $ docker run -p 3000:3000 ruby-for-bitnami-bitnami-docker-ruby
##
## CONNECTING
##   Lookup the IP of your active docker host using:
##     $ docker-machine ip $(docker-machine active)
##   Connect to the container at DOCKER_IP:3000
##     replacing DOCKER_IP for the IP of your active docker host

FROM gcr.io/stacksmith-images/ubuntu-buildpack:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="aq2un49" \
    STACKSMITH_STACK_NAME="Ruby for bitnami/bitnami-docker-ruby" \
    STACKSMITH_STACK_PRIVATE="1"

RUN bitnami-pkg install ruby-2.3.1-2 --checksum 041625b9f363a99b2e66f0209a759abe7106232e0fcc3a970958bf73d5a4d9b0

ENV PATH=/opt/bitnami/ruby/bin:$PATH

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

RUN bitnami-pkg install imagemagick-6.7.5-10-3 --checksum 617e85a42c80f58c568f9bc7337e24c03e35cf4c7c22640407a7e1e16880cf88
RUN bitnami-pkg install mysql-libraries-10.1.13-0 --checksum 71ca428b619901123493503f8a99ccfa588e5afddd26e0d503a32cca1bc2a389
RUN bitnami-pkg install postgresql-libraries-9.5.3-0 --checksum d6499811161e9e97acfc3e0132a016bc2edcfd85374c9b5002359429bd8ab698

ENV BITNAMI_APP_NAME=ruby \
    BITNAMI_IMAGE_VERSION=2.3.1-r2

EXPOSE 3000
WORKDIR /app

CMD ["irb"]
