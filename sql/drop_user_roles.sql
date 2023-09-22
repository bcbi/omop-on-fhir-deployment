-- sql/drop_user_roles.sql
-- REASSIGN OWNED BY omop_admin TO postgres;
DROP DATABASE IF EXISTS synpuf_omop_on_fhir;

DROP OWNED BY omop_admin CASCADE;

DROP ROLE IF EXISTS omop_admin;

DROP OWNED BY omop_app CASCADE;

DROP ROLE IF EXISTS omop_app;

DROP OWNED BY omop_admin_user;

DROP ROLE IF EXISTS omop_admin_user;

DROP OWNED BY omop_app_user;

DROP ROLE IF EXISTS omop_app_user;

