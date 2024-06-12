FROM us-docker.pkg.dev/vorvan/dev/bitnami-keycloak-ubi9:latest as builder

WORKDIR /opt/bitnami/keycloak
USER 1001
RUN curl -L https://repo1.maven.org/maven2/org/bouncycastle/bc-fips/1.0.2.3/bc-fips-1.0.2.3.jar -o /opt/bitnami/keycloak/providers/bc-fips-1.0.2.3.jar \
    && curl -L https://repo1.maven.org/maven2/org/bouncycastle/bctls-fips/1.0.18/bctls-fips-1.0.18.jar -o /opt/bitnami/keycloak/providers/bctls-fips-1.0.18.jar \
    && curl -L https://repo1.maven.org/maven2/org/bouncycastle/bcpkix-fips/1.0.7/bcpkix-fips-1.0.7.jar -o /opt/bitnami/keycloak/providers/bcpkix-fips-1.0.7.jar
#RUN cp ./packages/keycloak-fips.keystore.* /opt/bitnami/keycloak/conf/server.keystore
#RUN cp ./packages/kc.java.security /opt/bitnami/keycloak/conf/

RUN /opt/bitnami/keycloak/bin/kc.sh build --features=fips --fips-mode=strict

FROM us-docker.pkg.dev/vorvan/dev/bitnami-keycloak-ubi9:latest
COPY --from=builder /opt/bitnami/keycloak/ /opt/bitnami/keycloak/

# docker build --no-cache --progress=plain -t us-docker.pkg.dev/vorvan/dev/bitnami-keycloak-fips:latest .
# docker push us-docker.pkg.dev/vorvan/dev/bitnami-keycloak-fips:latest
