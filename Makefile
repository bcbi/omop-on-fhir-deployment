all: initdb omop vocab data f-tables build-container  


fetch-vocabs:
	echo "Fetching vocabularies..."
	mkdir vocabulary_download_v5
	wget https://www.dropbox.com/scl/fi/ilmwaqayxr2k6eaisi0eg/vocabulary_download_v5.tar.gz?rlkey=hbtzkjrjvrh2wa2lnq10bej5r&dl=0 -O vocabulary_download_v5/vocabulary_download_v5.zip
	cd vocabulary_download_v5 && tar -xvzf vocabulary_download_v5.tar.gz 


initdb: 
	echo "Initializing database..."
	psql --echo-all --file sql/create_user_roles.sql 
	psql --echo-all --file sql/create_db.sql 
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-all --file sql/create_schemas.sql 

omop: 
	echo "Creating OMOP tables..."
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/OMOP_CDM_postgresql_5.3_ddl.sql

vocab:
	echo "Loading vocabularies..."
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-all --file sql/load_vocabs.sql

data: 
	echo "Loading data..."
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/load_synpuf.sql
	echo "Loading indices and constraints..."	
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/OMOP_CDM_postgresql_5.3_indices.sql
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/OMOP_CDM_postgresql_5.3_constraints.sql

f-tables: 
	echo "Creating FHIR tables..."
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/names.sql
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/omoponfhir_f_person_ddl.sql
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/insert_names_to_f_person.sql
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/omoponfhir_f_cache_ddl.sql
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/omoponfhir_v5.3_f_immunization_view_ddl.sql
	psql --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/omoponfhir_v5.3_f_observation_view_ddl.sql

build-container:
	echo "Building FHIR server container..."
	cd omoponfhir-main-v531-r4 && git submodule update --init
	cd omoponfhir-main-v531-r4 && docker build -t omoponfhir . 

start: 
	cd omoponfhir-main-v531-r4 && docker run --publish 8080:8080 omoponfhir

get-capabilities:
	curl --request GET --location http://localhost:8080/fhir/metadata

get-epilepsy:
	curl --request GET --location http://localhost:8080/fhir/Condition?code=84757009&_pretty=true 

clean:
	echo "Cleaning up..."
	psql --command="DROP DATABASE IF EXISTS omop_on_fhir;"	
	psql --echo-all --file sql/drop_user_roles.sql


.PHONY: all initdb omop vocab data build-container f-tables start clean