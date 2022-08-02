#!/bin/bash
source .env
[ "${PROXY_PORT}" == "web" ] && PROXY_PROTO=http || PROXY_PROTO=https
# TODO wait until keycloak initializes
cat <<EOF
Monitoring Traefik: docker logs -f ${PROXY_CNAME}
The Admin dashboard is at: ${PROXY_PROTO}://${PROXY_HOST}/traefik/
EOF
[ "${PROXY_PORT}" == "websecure" ] && warning "Certbot is disabled by default."


