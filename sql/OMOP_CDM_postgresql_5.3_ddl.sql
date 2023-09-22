/*********************************************************************************
# Copyright 2017-11 Observational Health Data Sciences and Informatics
#
#
# Licensed under the Apache License, Version 2.0 (the "License")
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
 ********************************************************************************/
/************************

 ####### #     # ####### ######      #####  ######  #     #           #######      #####
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #           #     #
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #                 #
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######       #####
 #     # #     # #     # #          #       #     # #     #    #    #       # ###       #
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ### #     #
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ###  #####


postgresql script to create OMOP common data model version 5.3

last revised: 14-June-2018

Authors:  Patrick Ryan, Christian Reich, Clair Blacketer
 *************************/
/************************

Standardized vocabulary
 ************************/
CREATE TABLE public.concept(
  concept_id integer NOT NULL,
  concept_name text NOT NULL,
  domain_id text NOT NULL,
  vocabulary_id text NOT NULL,
  concept_class_id text NOT NULL,
  standard_concept text NULL,
  concept_code text NOT NULL,
  valid_start_date date NOT NULL,
  valid_end_date date NOT NULL,
  invalid_reason text NULL
);

CREATE TABLE public.vocabulary(
  vocabulary_id text NOT NULL,
  vocabulary_name text NOT NULL,
  vocabulary_reference text NOT NULL,
  vocabulary_version text NULL,
  vocabulary_concept_id integer NOT NULL
);

CREATE TABLE public.domain(
  domain_id text NOT NULL,
  domain_name text NOT NULL,
  domain_concept_id integer NOT NULL
);

CREATE TABLE public.concept_class(
  concept_class_id text NOT NULL,
  concept_class_name text NOT NULL,
  concept_class_concept_id integer NOT NULL
);

CREATE TABLE public.concept_relationship(
  concept_id_1 integer NOT NULL,
  concept_id_2 integer NOT NULL,
  relationship_id text NOT NULL,
  valid_start_date date NOT NULL,
  valid_end_date date NOT NULL,
  invalid_reason text NULL
);

CREATE TABLE public.relationship(
  relationship_id text NOT NULL,
  relationship_name text NOT NULL,
  is_hierarchical text NOT NULL,
  defines_ancestry text NOT NULL,
  reverse_relationship_id text NOT NULL,
  relationship_concept_id integer NOT NULL
);

CREATE TABLE public.concept_synonym(
  concept_id integer NOT NULL,
  concept_synonym_name text NOT NULL,
  language_concept_id integer NOT NULL
);

CREATE TABLE public.concept_ancestor(
  ancestor_concept_id integer NOT NULL,
  descendant_concept_id integer NOT NULL,
  min_levels_of_separation integer NOT NULL,
  max_levels_of_separation integer NOT NULL
);

CREATE TABLE public.source_to_concept_map(
  source_code text NOT NULL,
  source_concept_id integer NOT NULL,
  source_vocabulary_id text NOT NULL,
  source_code_description text NULL,
  target_concept_id integer NOT NULL,
  target_vocabulary_id text NOT NULL,
  valid_start_date date NOT NULL,
  valid_end_date date NOT NULL,
  invalid_reason text NULL
);

CREATE TABLE public.drug_strength(
  drug_concept_id integer NOT NULL,
  ingredient_concept_id integer NOT NULL,
  amount_value numeric NULL,
  amount_unit_concept_id integer NULL,
  numerator_value numeric NULL,
  numerator_unit_concept_id integer NULL,
  denominator_value numeric NULL,
  denominator_unit_concept_id integer NULL,
  box_size integer NULL,
  valid_start_date date NOT NULL,
  valid_end_date date NOT NULL,
  invalid_reason text NULL
);

CREATE TABLE public.cohort_definition(
  cohort_definition_id integer NOT NULL,
  cohort_definition_name text NOT NULL,
  cohort_definition_description text NULL,
  definition_type_concept_id integer NOT NULL,
  cohort_definition_syntax text NULL,
  subject_concept_id integer NOT NULL,
  cohort_initiation_date date NULL
);

CREATE TABLE public.attribute_definition(
  attribute_definition_id integer NOT NULL,
  attribute_name text NOT NULL,
  attribute_description text NULL,
  attribute_type_concept_id integer NOT NULL,
  attribute_syntax text NULL
);


/**************************

Standardized meta-data
 ***************************/
CREATE TABLE public.cdm_source(
  cdm_source_name text NOT NULL,
  cdm_source_abbreviation text NULL,
  cdm_holder text NULL,
  source_description text NULL,
  source_documentation_reference text NULL,
  cdm_etl_reference text NULL,
  source_release_date date NULL,
  cdm_release_date date NULL,
  cdm_version text NULL,
  vocabulary_version text NULL
);

CREATE TABLE public.metadata(
  metadata_concept_id integer NOT NULL,
  metadata_type_concept_id integer NOT NULL,
  name text NOT NULL,
  value_as_string text NULL,
  value_as_concept_id integer NULL,
  metadata_date date NULL,
  metadata_datetime timestamp NULL
);


/************************

Standardized clinical data
 ************************/
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.person(
  person_id integer NOT NULL,
  gender_concept_id integer NOT NULL,
  year_of_birth integer NOT NULL,
  month_of_birth integer NULL,
  day_of_birth integer NULL,
  birth_datetime timestamp NULL,
  race_concept_id integer NOT NULL,
  ethnicity_concept_id integer NOT NULL,
  location_id integer NULL,
  provider_id integer NULL,
  care_site_id integer NULL,
  person_source_value text NULL,
  gender_source_value text NULL,
  gender_source_concept_id integer NULL,
  race_source_value text NULL,
  race_source_concept_id integer NULL,
  ethnicity_source_value text NULL,
  ethnicity_source_concept_id integer NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.observation_period(
  observation_period_id integer NOT NULL,
  person_id integer NOT NULL,
  observation_period_start_date date NOT NULL,
  observation_period_end_date date NOT NULL,
  period_type_concept_id integer NOT NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.specimen(
  specimen_id integer NOT NULL,
  person_id integer NOT NULL,
  specimen_concept_id integer NOT NULL,
  specimen_type_concept_id integer NOT NULL,
  specimen_date date NOT NULL,
  specimen_datetime timestamp NULL,
  quantity numeric NULL,
  unit_concept_id integer NULL,
  anatomic_site_concept_id integer NULL,
  disease_status_concept_id integer NULL,
  specimen_source_id text NULL,
  specimen_source_value text NULL,
  unit_source_value text NULL,
  anatomic_site_source_value text NULL,
  disease_status_source_value text NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.death(
  person_id integer NOT NULL,
  death_date date NOT NULL,
  death_datetime timestamp NULL,
  death_type_concept_id integer NOT NULL,
  cause_concept_id integer NULL,
  cause_source_value text NULL,
  cause_source_concept_id integer NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.visit_occurrence(
  visit_occurrence_id integer NOT NULL,
  person_id integer NOT NULL,
  visit_concept_id integer NOT NULL,
  visit_start_date date NOT NULL,
  visit_start_datetime timestamp NULL,
  visit_end_date date NOT NULL,
  visit_end_datetime timestamp NULL,
  visit_type_concept_id integer NOT NULL,
  provider_id integer NULL,
  care_site_id integer NULL,
  visit_source_value text NULL,
  visit_source_concept_id integer NULL,
  admitting_source_concept_id integer NULL,
  admitting_source_value text NULL,
  discharge_to_concept_id integer NULL,
  discharge_to_source_value text NULL,
  preceding_visit_occurrence_id integer NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.visit_detail(
  visit_detail_id integer NOT NULL,
  person_id integer NOT NULL,
  visit_detail_concept_id integer NOT NULL,
  visit_detail_start_date date NOT NULL,
  visit_detail_start_datetime timestamp NULL,
  visit_detail_end_date date NOT NULL,
  visit_detail_end_datetime timestamp NULL,
  visit_detail_type_concept_id integer NOT NULL,
  provider_id integer NULL,
  care_site_id integer NULL,
  admitting_source_concept_id integer NULL,
  discharge_to_concept_id integer NULL,
  preceding_visit_detail_id integer NULL,
  visit_detail_source_value text NULL,
  visit_detail_source_concept_id integer NULL,
  admitting_source_value text NULL,
  discharge_to_source_value text NULL,
  visit_detail_parent_id integer NULL,
  visit_occurrence_id integer NOT NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.procedure_occurrence(
  procedure_occurrence_id integer NOT NULL,
  person_id integer NOT NULL,
  procedure_concept_id integer NOT NULL,
  procedure_date date NOT NULL,
  procedure_datetime timestamp NULL,
  procedure_type_concept_id integer NOT NULL,
  modifier_concept_id integer NULL,
  quantity integer NULL,
  provider_id integer NULL,
  visit_occurrence_id integer NULL,
  visit_detail_id integer NULL,
  procedure_source_value text NULL,
  procedure_source_concept_id integer NULL,
  modifier_source_value text NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.drug_exposure(
  drug_exposure_id integer NOT NULL,
  person_id integer NOT NULL,
  drug_concept_id integer NOT NULL,
  drug_exposure_start_date date NOT NULL,
  drug_exposure_start_datetime timestamp NULL,
  drug_exposure_end_date date NOT NULL,
  drug_exposure_end_datetime timestamp NULL,
  verbatim_end_date date NULL,
  drug_type_concept_id integer NOT NULL,
  stop_reason text NULL,
  refills integer NULL,
  quantity numeric NULL,
  days_supply integer NULL,
  sig text NULL,
  route_concept_id integer NULL,
  lot_number text NULL,
  provider_id integer NULL,
  visit_occurrence_id integer NULL,
  visit_detail_id integer NULL,
  drug_source_value text NULL,
  drug_source_concept_id integer NULL,
  route_source_value text NULL,
  dose_unit_source_value text NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.device_exposure(
  device_exposure_id integer NOT NULL,
  person_id integer NOT NULL,
  device_concept_id integer NOT NULL,
  device_exposure_start_date date NOT NULL,
  device_exposure_start_datetime timestamp NULL,
  device_exposure_end_date date NULL,
  device_exposure_end_datetime timestamp NULL,
  device_type_concept_id integer NOT NULL,
  unique_device_id text NULL,
  quantity integer NULL,
  provider_id integer NULL,
  visit_occurrence_id integer NULL,
  visit_detail_id integer NULL,
  device_source_value text NULL,
  device_source_concept_id integer NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.condition_occurrence(
  condition_occurrence_id integer NOT NULL,
  person_id integer NOT NULL,
  condition_concept_id integer NOT NULL,
  condition_start_date date NOT NULL,
  condition_start_datetime timestamp NULL,
  condition_end_date date NULL,
  condition_end_datetime timestamp NULL,
  condition_type_concept_id integer NOT NULL,
  stop_reason text NULL,
  provider_id integer NULL,
  visit_occurrence_id integer NULL,
  visit_detail_id integer NULL,
  condition_source_value text NULL,
  condition_source_concept_id integer NULL,
  condition_status_source_value text NULL,
  condition_status_concept_id integer NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.measurement(
  measurement_id integer NOT NULL,
  person_id integer NOT NULL,
  measurement_concept_id integer NOT NULL,
  measurement_date date NOT NULL,
  measurement_datetime timestamp NULL,
  measurement_time text NULL,
  measurement_type_concept_id integer NOT NULL,
  operator_concept_id integer NULL,
  value_as_number numeric NULL,
  value_as_concept_id integer NULL,
  unit_concept_id integer NULL,
  range_low numeric NULL,
  range_high numeric NULL,
  provider_id integer NULL,
  visit_occurrence_id integer NULL,
  visit_detail_id integer NULL,
  measurement_source_value text NULL,
  measurement_source_concept_id integer NULL,
  unit_source_value text NULL,
  value_source_value text NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.note(
  note_id integer NOT NULL,
  person_id integer NOT NULL,
  note_date date NOT NULL,
  note_datetime timestamp NULL,
  note_type_concept_id integer NOT NULL,
  note_class_concept_id integer NOT NULL,
  note_title text NULL,
  note_text text NULL,
  encoding_concept_id integer NOT NULL,
  language_concept_id integer NOT NULL,
  provider_id integer NULL,
  visit_occurrence_id integer NULL,
  visit_detail_id integer NULL,
  note_source_value text NULL
);

CREATE TABLE public.note_nlp(
  note_nlp_id integer NOT NULL,
  note_id integer NOT NULL,
  section_concept_id integer NULL,
  snippet text NULL,
  "offset" text NULL,
  lexical_variant text NOT NULL,
  note_nlp_concept_id integer NULL,
  note_nlp_source_concept_id integer NULL,
  nlp_system text NULL,
  nlp_date date NOT NULL,
  nlp_datetime timestamp NULL,
  term_exists text NULL,
  term_temporal text NULL,
  term_modifiers text NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.observation(
  observation_id integer NOT NULL,
  person_id integer NOT NULL,
  observation_concept_id integer NOT NULL,
  observation_date date NOT NULL,
  observation_datetime timestamp NULL,
  observation_type_concept_id integer NOT NULL,
  value_as_number numeric NULL,
  value_as_string text NULL,
  value_as_concept_id integer NULL,
  qualifier_concept_id integer NULL,
  unit_concept_id integer NULL,
  provider_id integer NULL,
  visit_occurrence_id integer NULL,
  visit_detail_id integer NULL,
  observation_source_value text NULL,
  observation_source_concept_id integer NULL,
  unit_source_value text NULL,
  qualifier_source_value text NULL
);

CREATE TABLE public.fact_relationship(
  domain_concept_id_1 integer NOT NULL,
  fact_id_1 integer NOT NULL,
  domain_concept_id_2 integer NOT NULL,
  fact_id_2 integer NOT NULL,
  relationship_concept_id integer NOT NULL
);


/************************

Standardized health system data
 ************************/
CREATE TABLE public.location(
  location_id integer NOT NULL,
  address_1 text NULL,
  address_2 text NULL,
  city text NULL,
  state text NULL,
  zip text NULL,
  county text NULL,
  location_source_value text NULL
);

CREATE TABLE public.care_site(
  care_site_id integer NOT NULL,
  care_site_name text NULL,
  place_of_service_concept_id integer NULL,
  location_id integer NULL,
  care_site_source_value text NULL,
  place_of_service_source_value text NULL
);

CREATE TABLE public.provider(
  provider_id integer NOT NULL,
  provider_name text NULL,
  NPI text NULL,
  DEA text NULL,
  specialty_concept_id integer NULL,
  care_site_id integer NULL,
  year_of_birth integer NULL,
  gender_concept_id integer NULL,
  provider_source_value text NULL,
  specialty_source_value text NULL,
  specialty_source_concept_id integer NULL,
  gender_source_value text NULL,
  gender_source_concept_id integer NULL
);


/************************

Standardized health economics
 ************************/
--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.payer_plan_period(
  payer_plan_period_id integer NOT NULL,
  person_id integer NOT NULL,
  payer_plan_period_start_date date NOT NULL,
  payer_plan_period_end_date date NOT NULL,
  payer_concept_id integer NULL,
  payer_source_value text NULL,
  payer_source_concept_id integer NULL,
  plan_concept_id integer NULL,
  plan_source_value text NULL,
  plan_source_concept_id integer NULL,
  sponsor_concept_id integer NULL,
  sponsor_source_value text NULL,
  sponsor_source_concept_id integer NULL,
  family_source_value text NULL,
  stop_reason_concept_id integer NULL,
  stop_reason_source_value text NULL,
  stop_reason_source_concept_id integer NULL
);

CREATE TABLE public.cost(
  cost_id integer NOT NULL,
  cost_event_id integer NOT NULL,
  cost_domain_id text NOT NULL,
  cost_type_concept_id integer NOT NULL,
  currency_concept_id integer NULL,
  total_charge numeric NULL,
  total_cost numeric NULL,
  total_paid numeric NULL,
  paid_by_payer numeric NULL,
  paid_by_patient numeric NULL,
  paid_patient_copay numeric NULL,
  paid_patient_coinsurance numeric NULL,
  paid_patient_deductible numeric NULL,
  paid_by_primary numeric NULL,
  paid_ingredient_cost numeric NULL,
  paid_dispensing_fee numeric NULL,
  payer_plan_period_id integer NULL,
  amount_allowed numeric NULL,
  revenue_code_concept_id integer NULL,
  reveue_code_source_value text NULL,
  drg_concept_id integer NULL,
  drg_source_value text NULL
);


/************************

Standardized derived elements
 ************************/
--HINT DISTRIBUTE_ON_KEY(subject_id)
CREATE TABLE public.cohort(
  cohort_definition_id integer NOT NULL,
  subject_id integer NOT NULL,
  cohort_start_date date NOT NULL,
  cohort_end_date date NOT NULL
);

--HINT DISTRIBUTE_ON_KEY(subject_id)
CREATE TABLE public.cohort_attribute(
  cohort_definition_id integer NOT NULL,
  subject_id integer NOT NULL,
  cohort_start_date date NOT NULL,
  cohort_end_date date NOT NULL,
  attribute_definition_id integer NOT NULL,
  value_as_number numeric NULL,
  value_as_concept_id integer NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.drug_era(
  drug_era_id integer NOT NULL,
  person_id integer NOT NULL,
  drug_concept_id integer NOT NULL,
  drug_era_start_date date NOT NULL,
  drug_era_end_date date NOT NULL,
  drug_exposure_count integer NULL,
  gap_days integer NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.dose_era(
  dose_era_id integer NOT NULL,
  person_id integer NOT NULL,
  drug_concept_id integer NOT NULL,
  unit_concept_id integer NOT NULL,
  dose_value numeric NOT NULL,
  dose_era_start_date date NOT NULL,
  dose_era_end_date date NOT NULL
);

--HINT DISTRIBUTE_ON_KEY(person_id)
CREATE TABLE public.condition_era(
  condition_era_id integer NOT NULL,
  person_id integer NOT NULL,
  condition_concept_id integer NOT NULL,
  condition_era_start_date date NOT NULL,
  condition_era_end_date date NOT NULL,
  condition_occurrence_count integer NULL
);

