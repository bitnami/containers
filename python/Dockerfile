FROM redhat/ubi9:9.4

ENV LIBGCRYPT_FORCE_FIPS_MODE=1

RUN yum install -y python3
RUN fips-mode-setup --enable --no-bootcfg
#COPY *.sh .
COPY openssl_fips.cnf .
RUN cp openssl_fips.cnf /etc/pki/tls/openssl_fips.cnf
#RUN sh ./fips-init.sh /etc/pki/tls/openssl_fips.cnf
#RUN sh ./fips-mode.sh
#RUN openssl version -a
#RUN cat /etc/crypto-policies/back-ends/openssl.config
#RUN openssl list -providers

ENV OPENSSL_CONF=/etc/pki/tls/openssl_fips.cnf
ENV OPENSSL_FIPS=1
RUN openssl list -providers
# docker build --no-cache --progress=plain -t us-docker.pkg.dev/vorvan/dev/python-fips:latest .
# docker push us-docker.pkg.dev/vorvan/dev/python-fips:latest
