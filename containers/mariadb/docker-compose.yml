version: '2'

services:
  mariadb:
    image: 'bitnami/mariadb:latest'
    labels:
      kompose.service.type: nodeport
    ports:
      - '3306:3306'
    volumes:
      - 'mariadb_data:/bitnami/mariadb'
    environment:
      # ALLOW_EMPTY_PASSWORD is recommended only for development.
      - ALLOW_EMPTY_PASSWORD=yes

volumes:
  mariadb_data:
    driver: local
