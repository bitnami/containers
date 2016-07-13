## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami-bitnami-docker-ruby .
##
## RUNNING
##   $ docker run -p 3000:3000 bitnami-bitnami-docker-ruby
##
## CONNECTING
##   Lookup the IP of your active docker host using:
##     $ docker-machine ip $(docker-machine active)
##   Connect to the container at DOCKER_IP:3000
##     replacing DOCKER_IP for the IP of your active docker host

FROM gcr.io/stacksmith-images/ubuntu-buildpack:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="tanl42b" \
    STACKSMITH_STACK_NAME="bitnami/bitnami-docker-ruby" \
    STACKSMITH_STACK_PRIVATE="1"

RUN bitnami-pkg install ruby-2.3.1-1 --checksum a81395976c85e8b7c8da3c1db6385d0e909bd05d9a3c1527f8fa36b8eb093d84

ENV PATH=/opt/bitnami/ruby/bin:$PATH

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

# Ruby base template
COPY Gemfile* /app/
WORKDIR /app

RUN bundle install

COPY . /app

CMD ["irb"]
