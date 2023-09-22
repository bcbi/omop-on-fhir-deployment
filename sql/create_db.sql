DROP DATABASE IF EXISTS synpuf_omop_on_fhir;

CREATE DATABASE synpuf_omop_on_fhir WITH ENCODING = 'UTF8' OWNER = omop_admin CONNECTION LIMIT = - 1;

GRANT ALL ON DATABASE synpuf_omop_on_fhir TO
GROUP omop_admin;

GRANT CONNECT, TEMPORARY ON DATABASE synpuf_omop_on_fhir TO
GROUP omop_app;

