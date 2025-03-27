#!/bin/bash
set -e;

# Create the non-root user for n8n to connect with
if [ -n "${POSTGRES_NON_ROOT_USER:-}" ] && [ -n "${POSTGRES_NON_ROOT_PASSWORD:-}" ]; then
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
		CREATE USER ${POSTGRES_NON_ROOT_USER} WITH PASSWORD '${POSTGRES_NON_ROOT_PASSWORD}';
		GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
		GRANT CREATE ON SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
	EOSQL
	echo "SETUP INFO: Created user ${POSTGRES_NON_ROOT_USER}"
else
	echo "SETUP INFO: No Environment variables given for non-root user!"
fi

# Create the n8n_admin role that appears in the error logs
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER n8n_admin WITH PASSWORD 'n8n_admin_password';
	GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO n8n_admin;
	GRANT CREATE ON SCHEMA public TO n8n_admin;
EOSQL
echo "SETUP INFO: Created user n8n_admin"