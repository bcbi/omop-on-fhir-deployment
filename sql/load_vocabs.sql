\copy public.concept FROM '/Users/pstey/projects/omop-on-fhir-deployment-pipeline/vocabulary_download_v5/data/CONCEPT.csv' ENCODING 'UTF8' HEADER CSV DELIMITER E'\t' QUOTE E'\b';
\copy public.concept_class FROM '/Users/pstey/projects/omop-on-fhir-deployment-pipeline/vocabulary_download_v5/data/CONCEPT_CLASS.csv' HEADER CSV DELIMITER E'\t';
\copy public.concept_ancestor FROM '/Users/pstey/projects/omop-on-fhir-deployment-pipeline/vocabulary_download_v5/data/CONCEPT_ANCESTOR.csv' HEADER CSV DELIMITER E'\t';
\copy public.concept_relationship FROM '/Users/pstey/projects/omop-on-fhir-deployment-pipeline/vocabulary_download_v5/data/CONCEPT_RELATIONSHIP.csv' HEADER CSV DELIMITER E'\t';
\copy public.concept_synonym FROM '/Users/pstey/projects/omop-on-fhir-deployment-pipeline/vocabulary_download_v5/data/CONCEPT_SYNONYM.csv' HEADER CSV DELIMITER E'\t';
\copy public.domain FROM '/Users/pstey/projects/omop-on-fhir-deployment-pipeline/vocabulary_download_v5/data/DOMAIN.csv' HEADER CSV DELIMITER E'\t';
\copy public.drug_strength FROM '/Users/pstey/projects/omop-on-fhir-deployment-pipeline/vocabulary_download_v5/data/DRUG_STRENGTH.csv' HEADER CSV DELIMITER E'\t';
\copy public.relationship FROM '/Users/pstey/projects/omop-on-fhir-deployment-pipeline/vocabulary_download_v5/data/RELATIONSHIP.csv' HEADER CSV DELIMITER E'\t';
\copy public.vocabulary FROM '/Users/pstey/projects/omop-on-fhir-deployment-pipeline/vocabulary_download_v5/data/VOCABULARY.csv' HEADER CSV DELIMITER E'\t';
