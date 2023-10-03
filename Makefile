all: initdb omop vocab data f-tables build-container  

HOST=pdbmedcit.services.brown.edu

fetch-vocabs:
	echo "Fetching vocabularies..."
	curl --output vocabulary_download_v5.tar.gz --location https://www.dropbox.com/scl/fi/ilmwaqayxr2k6eaisi0eg/vocabulary_download_v5.tar.gz?rlkey=hbtzkjrjvrh2wa2lnq10bej5r&dl=0  
	
untar-vocabs:	
	tar --warning=no-unknown-keyword -xvzf vocabulary_download_v5.tar.gz 
	rm vocabulary_download_v5/data/._*.csv

initdb: 
	echo "Initializing database..."
	psql --host $(HOST) --echo-all --file sql/create_user_roles.sql 
	psql --host $(HOST) --echo-all --file sql/create_db.sql 
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-all --file sql/create_schemas.sql 

omop: 
	echo "Creating OMOP tables..."
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/OMOP_CDM_postgresql_5.3_ddl.sql

vocab:
	echo "Loading vocabularies..."
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-all --file sql/load_vocabs.sql

data: 
	echo "Loading data..."
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/load_synpuf.sql
	echo "Loading indices and constraints..."	
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/OMOP_CDM_postgresql_5.3_indices.sql
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/OMOP_CDM_postgresql_5.3_constraints.sql

f-tables: 
	echo "Creating FHIR tables..."
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/names.sql
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/omoponfhir_f_person_ddl.sql
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/insert_names_to_f_person.sql
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/omoponfhir_f_cache_ddl.sql
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/omoponfhir_v5.3_f_immunization_view_ddl.sql
	psql --host $(HOST) --username omop_admin_user --dbname synpuf_omop_on_fhir --echo-errors --file sql/omoponfhir_v5.3_f_observation_view_ddl.sql

build-container:
	echo "Building FHIR server container..."
	cd omoponfhir-main-v531-r4 && git submodule update --init
	cd omoponfhir-main-v531-r4 && docker build -t omoponfhir . 

start: 
	cd omoponfhir-main-v531-r4 && docker run --detach --publish 8080:8080 omoponfhir

get-capabilities:
	curl --request GET --location http://localhost:8080/fhir/metadata

get-epilepsy:
	curl --request GET --location http://localhost:8080/fhir/Condition?code=84757009&_pretty=true 

clean:
	echo "Cleaning up..."
	psql --command="DROP DATABASE IF EXISTS omop_on_fhir;"	
	psql --echo-all --file sql/drop_user_roles.sql


.PHONY: all initdb omop vocab data build-container f-tables start clean
