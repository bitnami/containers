fips-jars:
	mkdir -p ./packages
	wget https://repo1.maven.org/maven2/org/bouncycastle/bc-fips/1.0.2.5/bc-fips-1.0.2.5.jar -O ./packages/bc-fips-1.0.2.5.jar
	wget https://repo1.maven.org/maven2/org/bouncycastle/bctls-fips/1.0.19/bctls-fips-1.0.19.jar -O ./packages/bctls-fips-1.0.19.jar
	wget https://repo1.maven.org/maven2/org/bouncycastle/bcpkix-fips/1.0.7/bcpkix-fips-1.0.7.jar -O ./packages/bcpkix-fips-1.0.7.jar

gen-keystore:
	keytool -keystore $KEYCLOAK_HOME/conf/server.keystore \
      -storetype bcfks \
      -providername BCFIPS \
      -providerclass org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider \
      -provider org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider \
      -providerpath $KEYCLOAK_HOME/providers/bc-fips-*.jar \
      -alias localhost \
      -genkeypair -sigalg SHA512withRSA -keyalg RSA -storepass passwordpassword \
      -dname CN=localhost -keypass passwordpassword \
      -J-Djava.security.properties=/tmp/kc.keystore-create.java.security
