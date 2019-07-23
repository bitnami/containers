#!/bin/bash -e

echo "Installing openssl prerequisites"
apt-get update && \
    apt-get install -y openssl && \
    apt-get clean

function generate_ca() {
    echo "Generating CA Private Key"
    openssl genrsa -out mongoCA.key -aes256 2048
    echo "Generating CA Certificate"
    openssl req -x509 -new -extensions v3_ca -key mongoCA.key -days 365 -out mongoCA.crt
}

function generate_certificate() {
    HOST_NAME="$1"

    cat > $HOST_NAME.conf << EOH
[ req ]
distinguished_name = req_distinguished_name
req_extensions     = v3_req

[ req_distinguished_name ]
countryName_default         = US
stateOrProvinceName_default = NY
localityName_default        = New York
organizationalUnitName_default = ACME Organizational Unit
commonName_default             = $HOST_NAME

[ v3_req ]
extendedKeyUsage = clientAuth,serverAuth
subjectAltName   = @alt_names

[ alt_names ]
DNS.1 = $HOST_NAME
EOH

    echo "Generating CSR for $HOST_NAME - creating key"
    openssl req -new -nodes -newkey rsa:4096 \
        -subj "/CN=${HOST_NAME}" \
        -config ${HOST_NAME}.conf \
        -keyout $HOST_NAME.key -out $HOST_NAME.csr

    echo "Generating CRT from CSR - creating certificate"
    openssl x509 \
        -req -days 365 -in $HOST_NAME.csr -out $HOST_NAME.crt \
        -CA mongoCA.crt -CAkey mongoCA.key -CAcreateserial \
        -extensions req -extensions v3_req -extfile ${HOST_NAME}.conf
    rm $HOST_NAME.csr
    cat $HOST_NAME.key $HOST_NAME.crt > $HOST_NAME.pem
    rm $HOST_NAME.key
    rm $HOST_NAME.conf

    # openssl x509 -in $HOST_NAME.crt -text -noout
    rm $HOST_NAME.crt
}

generate_ca

generate_certificate mongodb-primary
generate_certificate mongodb-secondary
generate_certificate mongodb-arbiter
generate_certificate mongodb-client