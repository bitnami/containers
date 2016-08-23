FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=redmine \
    BITNAMI_IMAGE_VERSION=3.3.0-r1 \
    PATH=/opt/bitnami/ruby/bin:$PATH

# Additional modules required
RUN bitnami-pkg install ruby-2.1.9-2 --checksum d9a014bb284fe1bd181008aa7f78b70b5259a93014a175df0a7e42084b2e2dd4
RUN bitnami-pkg install imagemagick-6.7.5-10-3 --checksum 617e85a42c80f58c568f9bc7337e24c03e35cf4c7c22640407a7e1e16880cf88
RUN bitnami-pkg install mysql-libraries-10.1.13-0 --checksum 71ca428b619901123493503f8a99ccfa588e5afddd26e0d503a32cca1bc2a389
RUN bitnami-pkg install mysql-client-10.1.13-1 --checksum e16c0ace5cb779b486e52af83a56367f26af16a25b4ab92d8f4293f1bf307107

# Install redmine
RUN bitnami-pkg unpack redmine-3.3.0-0 --checksum 7635b0f9585ad8a950c632eff9220ef84a1c455e07c02418265cbada8a73f9ff

COPY rootfs /

VOLUME ["/bitnami/redmine"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "redmine"]
