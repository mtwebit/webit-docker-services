#!/bin/bash
source .env
[ "${KEYCLOAK_PORT}" == "web" ] && KEYCLOAK_PROTO=http || KEYCLOAK_PROTO=https
# TODO wait until keycloak initializes
cat <<EOF
You can monitor Keycloak using: docker logs -f ${KEYCLOAK_CNAME}
The Admin dashboard is at: ${KEYCLOAK_PROTO}://${KEYCLOAK_HOST}/auth/
Log in as "${KEYCLOAK_ADMIN}" password "${KEYCLOAK_ADMIN_PASSWORD}"
Change the admin password (Manage / Users / Admin / Credentials) and email.
Import the MW realm from 'mw-realm.json' (Select Realm / Add / Import file)
Configure the MW realm (Realm settings):
- Enable 'User Profile' (General tab) if not enabled.
- Set up email hosts, auth etc. (Email tab).
- Enable 'Verify email' (Login)
Import the MW user profile (Realm settings / User Profile / JSON Editor) by
copying 'mw-userProfile.json' into the editor (overwriting its content).
EOF
