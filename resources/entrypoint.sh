#!/bin/bash

dockerize -wait tcp://$DB_URI:5432 -timeout 300s

createdb -h $DB_URI -U $DB_USER redash
/opt/redash/current/manage.py database create_tables
/opt/redash/current/manage.py users create --admin --password admin "Admin" "admin"

run_psql="psql -h $DB_URI -U $DB_USER -d redash"
$run_psql -c "CREATE ROLE redash_reader WITH PASSWORD 'redash_reader' NOCREATEROLE NOCREATEDB NOSUPERUSER LOGIN"
$run_psql -c "grant select(id,name,type) ON data_sources to redash_reader;"
$run_psql -c "grant select(id,name) ON users to redash_reader;"
$run_psql -c "grant select on events, queries, dashboards, widgets, visualizations, query_results to redash_reader;"
$run_psql -c "insert into data_sources(org_id, name, type, options, queue_name, scheduled_queue_name, created_at) values (1, 'Presto', 'presto', '{\"catalog\": \"hive\", \"schema\": \"default\", \"host\": \"$METASTORE_URI\", \"port\": $METASTORE_PORT}', 'queries', 'scheduled_queries', '2016-08-10 17:02:07.820707+00');"

/opt/redash/current/manage.py ds new "re:dash metadata" --type "pg" --options "{\"user\": \"redash_reader\", \"password\": \"redash_reader\", \"host\": \"$DB_URI\", \"dbname\": \"redash\"}""\"}"

exec $@
