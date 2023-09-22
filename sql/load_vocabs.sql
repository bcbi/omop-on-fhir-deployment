\copy public.concept FROM '/opt/omop_on_fhir/omop-on-fhir-deployment/vocabulary_download_v5/data/CONCEPT.csv' ENCODING 'UTF8' HEADER CSV DELIMITER E'\t' QUOTE E'\b';
\copy public.concept_class FROM '/opt/omop_on_fhir/omop-on-fhir-deployment/vocabulary_download_v5/data/CONCEPT_CLASS.csv' HEADER CSV DELIMITER E'\t';
\copy public.concept_ancestor FROM '/opt/omop_on_fhir/omop-on-fhir-deployment/vocabulary_download_v5/data/CONCEPT_ANCESTOR.csv' HEADER CSV DELIMITER E'\t';
\copy public.concept_relationship FROM '/opt/omop_on_fhir/omop-on-fhir-deployment/vocabulary_download_v5/data/CONCEPT_RELATIONSHIP.csv' HEADER CSV DELIMITER E'\t';
\copy public.concept_synonym FROM '/opt/omop_on_fhir/omop-on-fhir-deployment/vocabulary_download_v5/data/CONCEPT_SYNONYM.csv' HEADER CSV DELIMITER E'\t';
\copy public.domain FROM '/opt/omop_on_fhir/omop-on-fhir-deployment/vocabulary_download_v5/data/DOMAIN.csv' HEADER CSV DELIMITER E'\t';
\copy public.drug_strength FROM '/opt/omop_on_fhir/omop-on-fhir-deployment/vocabulary_download_v5/data/DRUG_STRENGTH.csv' HEADER CSV DELIMITER E'\t';
\copy public.relationship FROM '/opt/omop_on_fhir/omop-on-fhir-deployment/vocabulary_download_v5/data/RELATIONSHIP.csv' HEADER CSV DELIMITER E'\t';
\copy public.vocabulary FROM '/opt/omop_on_fhir/omop-on-fhir-deployment/vocabulary_download_v5/data/VOCABULARY.csv' HEADER CSV DELIMITER E'\t';
