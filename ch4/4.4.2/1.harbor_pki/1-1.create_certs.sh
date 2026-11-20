#!/usr/bin/env bash

HARBOR_FILE_DIR=/opt/harbor
echo "[Step 1/6] Create Harbor file directory($HARBOR_FILE_DIR)"
mkdir -p $HARBOR_FILE_DIR

echo "[Step 2/6] Create CA key"
openssl genrsa -out $HARBOR_FILE_DIR/ca.key 4096

echo "[Step 3/6] Create CA certificate"
openssl req -x509 -new -noenc -sha512 -days 3650 \
        -config $(dirname "$0")/certificate.csr \
        -key $HARBOR_FILE_DIR/ca.key -out $HARBOR_FILE_DIR/ca.crt

echo "[Step 4/6] Create server certificate key"
openssl genrsa -out $HARBOR_FILE_DIR/server.key 4096

echo "[Step 5/6] Create server certificate CSR"
openssl req -new -sha512 \
        -config $(dirname "$0")/certificate.csr \
	-key $HARBOR_FILE_DIR/server.key -out $HARBOR_FILE_DIR/server.csr

echo "[Step 6/6] Create server certificate with signing"
openssl x509 -req -sha512 -days 3650 \
	-extfile $(dirname "$0")/certificate_v3.ext \
	-CA $HARBOR_FILE_DIR/ca.crt -CAkey $HARBOR_FILE_DIR/ca.key -CAcreateserial \
	-in $HARBOR_FILE_DIR/server.csr -out $HARBOR_FILE_DIR/server.crt
