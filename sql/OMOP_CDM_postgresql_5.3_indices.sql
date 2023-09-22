/*********************************************************************************
# Copyright 2014 Observational Health Data Sciences and Informatics
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
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

 ####### #     # ####### ######      #####  ######  #     #           #######      #####     ###
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #           #     #     #  #    # #####  ###### #    # ######  ####
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #                 #     #  ##   # #    # #       #  #  #      #
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######       #####      #  # #  # #    # #####    ##   #####   ####
 #     # #     # #     # #          #       #     # #     #    #    #       # ###       #     #  #  # # #    # #        ##   #           #
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ### #     #     #  #   ## #    # #       #  #  #      #    #
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ###  #####     ### #    # #####  ###### #    # ######  ####


postgresql script to create the required indexes within OMOP common data model, version 5.3

last revised: 14-November-2017

author:  Patrick Ryan, Clair Blacketer

description:  These primary keys and indices are considered a minimal requirement to ensure adequate performance of analyses.
 *************************/
/************************
 *************************
 *************************
 *************************

Primary key constraints
 *************************
 *************************
 *************************
 ************************/
/************************

Standardized vocabulary
 ************************/
ALTER TABLE public.concept
    ADD CONSTRAINT xpk_concept PRIMARY KEY (concept_id);

ALTER TABLE public.vocabulary
    ADD CONSTRAINT xpk_vocabulary PRIMARY KEY (vocabulary_id);

ALTER TABLE public.domain
    ADD CONSTRAINT xpk_domain PRIMARY KEY (domain_id);

ALTER TABLE public.concept_class
    ADD CONSTRAINT xpk_concept_class PRIMARY KEY (concept_class_id);

ALTER TABLE public.concept_relationship
    ADD CONSTRAINT xpk_concept_relationship PRIMARY KEY (concept_id_1, concept_id_2, relationship_id);

ALTER TABLE public.relationship
    ADD CONSTRAINT xpk_relationship PRIMARY KEY (relationship_id);

ALTER TABLE public.concept_ancestor
    ADD CONSTRAINT xpk_concept_ancestor PRIMARY KEY (ancestor_concept_id, descendant_concept_id);

ALTER TABLE public.source_to_concept_map
    ADD CONSTRAINT xpk_source_to_concept_map PRIMARY KEY (source_vocabulary_id, target_concept_id, source_code, valid_end_date);

ALTER TABLE public.drug_strength
    ADD CONSTRAINT xpk_drug_strength PRIMARY KEY (drug_concept_id, ingredient_concept_id);

ALTER TABLE public.cohort_definition
    ADD CONSTRAINT xpk_cohort_definition PRIMARY KEY (cohort_definition_id);

ALTER TABLE public.attribute_definition
    ADD CONSTRAINT xpk_attribute_definition PRIMARY KEY (attribute_definition_id);


/**************************

Standardized meta-data
 ***************************/
/************************

Standardized clinical data
 ************************/
/**PRIMARY KEY NONCLUSTERED constraints**/
ALTER TABLE public.person
    ADD CONSTRAINT xpk_person PRIMARY KEY (person_id);

ALTER TABLE public.observation_period
    ADD CONSTRAINT xpk_observation_period PRIMARY KEY (observation_period_id);

ALTER TABLE public.specimen
    ADD CONSTRAINT xpk_specimen PRIMARY KEY (specimen_id);

ALTER TABLE public.death
    ADD CONSTRAINT xpk_death PRIMARY KEY (person_id);

ALTER TABLE public.visit_occurrence
    ADD CONSTRAINT xpk_visit_occurrence PRIMARY KEY (visit_occurrence_id);

ALTER TABLE public.visit_detail
    ADD CONSTRAINT xpk_visit_detail PRIMARY KEY (visit_detail_id);

ALTER TABLE public.procedure_occurrence
    ADD CONSTRAINT xpk_procedure_occurrence PRIMARY KEY (procedure_occurrence_id);

ALTER TABLE public.drug_exposure
    ADD CONSTRAINT xpk_drug_exposure PRIMARY KEY (drug_exposure_id);

ALTER TABLE public.device_exposure
    ADD CONSTRAINT xpk_device_exposure PRIMARY KEY (device_exposure_id);

ALTER TABLE public.condition_occurrence
    ADD CONSTRAINT xpk_condition_occurrence PRIMARY KEY (condition_occurrence_id);

ALTER TABLE public.measurement
    ADD CONSTRAINT xpk_measurement PRIMARY KEY (measurement_id);

ALTER TABLE public.note
    ADD CONSTRAINT xpk_note PRIMARY KEY (note_id);

ALTER TABLE public.note_nlp
    ADD CONSTRAINT xpk_note_nlp PRIMARY KEY (note_nlp_id);

ALTER TABLE public.observation
    ADD CONSTRAINT xpk_observation PRIMARY KEY (observation_id);


/************************

Standardized health system data
 ************************/
ALTER TABLE public.location
    ADD CONSTRAINT xpk_location PRIMARY KEY (location_id);

ALTER TABLE public.care_site
    ADD CONSTRAINT xpk_care_site PRIMARY KEY (care_site_id);

ALTER TABLE public.provider
    ADD CONSTRAINT xpk_provider PRIMARY KEY (provider_id);


/************************

Standardized health economics
 ************************/
ALTER TABLE public.payer_plan_period
    ADD CONSTRAINT xpk_payer_plan_period PRIMARY KEY (payer_plan_period_id);

ALTER TABLE public.cost
    ADD CONSTRAINT xpk_visit_cost PRIMARY KEY (cost_id);


/************************

Standardized derived elements
 ************************/
ALTER TABLE public.cohort
    ADD CONSTRAINT xpk_cohort PRIMARY KEY (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date);

ALTER TABLE public.cohort_attribute
    ADD CONSTRAINT xpk_cohort_attribute PRIMARY KEY (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date, attribute_definition_id);

ALTER TABLE public.drug_era
    ADD CONSTRAINT xpk_drug_era PRIMARY KEY (drug_era_id);

ALTER TABLE public.dose_era
    ADD CONSTRAINT xpk_dose_era PRIMARY KEY (dose_era_id);

ALTER TABLE public.condition_era
    ADD CONSTRAINT xpk_condition_era PRIMARY KEY (condition_era_id);


/************************
 *************************
 *************************
 *************************

Indices
 *************************
 *************************
 *************************
 ************************/
/************************

Standardized vocabulary
 ************************/
CREATE UNIQUE INDEX idx_concept_concept_id ON public.concept(concept_id ASC);

CLUSTER public.concept
USING idx_concept_concept_id;

CREATE INDEX idx_concept_code ON public.concept(concept_code ASC);

CREATE INDEX idx_concept_vocabluary_id ON public.concept(vocabulary_id ASC);

CREATE INDEX idx_concept_domain_id ON public.concept(domain_id ASC);

CREATE INDEX idx_concept_class_id ON public.concept(concept_class_id ASC);

CREATE UNIQUE INDEX idx_vocabulary_vocabulary_id ON public.vocabulary(vocabulary_id ASC);

CLUSTER public.vocabulary
USING idx_vocabulary_vocabulary_id;

CREATE UNIQUE INDEX idx_domain_domain_id ON public.domain(domain_id ASC);

CLUSTER public.domain
USING idx_domain_domain_id;

CREATE UNIQUE INDEX idx_concept_class_class_id ON public.concept_class(concept_class_id ASC);

CLUSTER public.concept_class
USING idx_concept_class_class_id;

CREATE INDEX idx_concept_relationship_id_1 ON public.concept_relationship(concept_id_1 ASC);

CREATE INDEX idx_concept_relationship_id_2 ON public.concept_relationship(concept_id_2 ASC);

CREATE INDEX idx_concept_relationship_id_3 ON public.concept_relationship(relationship_id ASC);

CREATE UNIQUE INDEX idx_relationship_rel_id ON public.relationship(relationship_id ASC);

CLUSTER public.relationship
USING idx_relationship_rel_id;

CREATE INDEX idx_concept_synonym_id ON public.concept_synonym(concept_id ASC);

CLUSTER public.concept_synonym
USING idx_concept_synonym_id;

CREATE INDEX idx_concept_ancestor_id_1 ON public.concept_ancestor(ancestor_concept_id ASC);

CLUSTER public.concept_ancestor
USING idx_concept_ancestor_id_1;

CREATE INDEX idx_concept_ancestor_id_2 ON public.concept_ancestor(descendant_concept_id ASC);

CREATE INDEX idx_source_to_concept_map_id_3 ON public.source_to_concept_map(target_concept_id ASC);

CLUSTER public.source_to_concept_map
USING idx_source_to_concept_map_id_3;

CREATE INDEX idx_source_to_concept_map_id_1 ON public.source_to_concept_map(source_vocabulary_id ASC);

CREATE INDEX idx_source_to_concept_map_id_2 ON public.source_to_concept_map(target_vocabulary_id ASC);

CREATE INDEX idx_source_to_concept_map_code ON public.source_to_concept_map(source_code ASC);

CREATE INDEX idx_drug_strength_id_1 ON public.drug_strength(drug_concept_id ASC);

CLUSTER public.drug_strength
USING idx_drug_strength_id_1;

CREATE INDEX idx_drug_strength_id_2 ON public.drug_strength(ingredient_concept_id ASC);

CREATE INDEX idx_cohort_definition_id ON public.cohort_definition(cohort_definition_id ASC);

CLUSTER public.cohort_definition
USING idx_cohort_definition_id;

CREATE INDEX idx_attribute_definition_id ON public.attribute_definition(attribute_definition_id ASC);

CLUSTER public.attribute_definition
USING idx_attribute_definition_id;


/**************************

Standardized meta-data
 ***************************/
/************************

Standardized clinical data
 ************************/
CREATE UNIQUE INDEX idx_person_id ON public.person(person_id ASC);

CLUSTER public.person
USING idx_person_id;

CREATE INDEX idx_observation_period_id ON public.observation_period(person_id ASC);

CLUSTER public.observation_period
USING idx_observation_period_id;

CREATE INDEX idx_specimen_person_id ON public.specimen(person_id ASC);

CLUSTER public.specimen
USING idx_specimen_person_id;

CREATE INDEX idx_specimen_concept_id ON public.specimen(specimen_concept_id ASC);

CREATE INDEX idx_death_person_id ON public.death(person_id ASC);

CLUSTER public.death
USING idx_death_person_id;

CREATE INDEX idx_visit_person_id ON public.visit_occurrence(person_id ASC);

CLUSTER public.visit_occurrence
USING idx_visit_person_id;

CREATE INDEX idx_visit_concept_id ON public.visit_occurrence(visit_concept_id ASC);

CREATE INDEX idx_visit_detail_person_id ON public.visit_detail(person_id ASC);

CLUSTER public.visit_detail
USING idx_visit_detail_person_id;

CREATE INDEX idx_visit_detail_concept_id ON public.visit_detail(visit_detail_concept_id ASC);

CREATE INDEX idx_procedure_person_id ON public.procedure_occurrence(person_id ASC);

CLUSTER public.procedure_occurrence
USING idx_procedure_person_id;

CREATE INDEX idx_procedure_concept_id ON public.procedure_occurrence(procedure_concept_id ASC);

CREATE INDEX idx_procedure_visit_id ON public.procedure_occurrence(visit_occurrence_id ASC);

CREATE INDEX idx_drug_person_id ON public.drug_exposure(person_id ASC);

CLUSTER public.drug_exposure
USING idx_drug_person_id;

CREATE INDEX idx_drug_concept_id ON public.drug_exposure(drug_concept_id ASC);

CREATE INDEX idx_drug_visit_id ON public.drug_exposure(visit_occurrence_id ASC);

CREATE INDEX idx_device_person_id ON public.device_exposure(person_id ASC);

CLUSTER public.device_exposure
USING idx_device_person_id;

CREATE INDEX idx_device_concept_id ON public.device_exposure(device_concept_id ASC);

CREATE INDEX idx_device_visit_id ON public.device_exposure(visit_occurrence_id ASC);

CREATE INDEX idx_condition_person_id ON public.condition_occurrence(person_id ASC);

CLUSTER public.condition_occurrence
USING idx_condition_person_id;

CREATE INDEX idx_condition_concept_id ON public.condition_occurrence(condition_concept_id ASC);

CREATE INDEX idx_condition_visit_id ON public.condition_occurrence(visit_occurrence_id ASC);

CREATE INDEX idx_measurement_person_id ON public.measurement(person_id ASC);

CLUSTER public.measurement
USING idx_measurement_person_id;

CREATE INDEX idx_measurement_concept_id ON public.measurement(measurement_concept_id ASC);

CREATE INDEX idx_measurement_visit_id ON public.measurement(visit_occurrence_id ASC);

CREATE INDEX idx_note_person_id ON public.note(person_id ASC);

CLUSTER public.note
USING idx_note_person_id;

CREATE INDEX idx_note_concept_id ON public.note(note_type_concept_id ASC);

CREATE INDEX idx_note_visit_id ON public.note(visit_occurrence_id ASC);

CREATE INDEX idx_note_nlp_note_id ON public.note_nlp(note_id ASC);

CLUSTER public.note_nlp
USING idx_note_nlp_note_id;

CREATE INDEX idx_note_nlp_concept_id ON public.note_nlp(note_nlp_concept_id ASC);

CREATE INDEX idx_observation_person_id ON public.observation(person_id ASC);

CLUSTER public.observation
USING idx_observation_person_id;

CREATE INDEX idx_observation_concept_id ON public.observation(observation_concept_id ASC);

CREATE INDEX idx_observation_visit_id ON public.observation(visit_occurrence_id ASC);

CREATE INDEX idx_fact_relationship_id_1 ON public.fact_relationship(domain_concept_id_1 ASC);

CREATE INDEX idx_fact_relationship_id_2 ON public.fact_relationship(domain_concept_id_2 ASC);

CREATE INDEX idx_fact_relationship_id_3 ON public.fact_relationship(relationship_concept_id ASC);


/************************

Standardized health system data
 ************************/
/************************

Standardized health economics
 ************************/
CREATE INDEX idx_period_person_id ON public.payer_plan_period(person_id ASC);

CLUSTER public.payer_plan_period
USING idx_period_person_id;


/************************

Standardized derived elements
 ************************/
CREATE INDEX idx_cohort_subject_id ON public.cohort(subject_id ASC);

CREATE INDEX idx_cohort_c_definition_id ON public.cohort(cohort_definition_id ASC);

CREATE INDEX idx_ca_subject_id ON public.cohort_attribute(subject_id ASC);

CREATE INDEX idx_ca_definition_id ON public.cohort_attribute(cohort_definition_id ASC);

CREATE INDEX idx_drug_era_person_id ON public.drug_era(person_id ASC);

CLUSTER public.drug_era
USING idx_drug_era_person_id;

CREATE INDEX idx_drug_era_concept_id ON public.drug_era(drug_concept_id ASC);

CREATE INDEX idx_dose_era_person_id ON public.dose_era(person_id ASC);

CLUSTER public.dose_era
USING idx_dose_era_person_id;

CREATE INDEX idx_dose_era_concept_id ON public.dose_era(drug_concept_id ASC);

CREATE INDEX idx_condition_era_person_id ON public.condition_era(person_id ASC);

CLUSTER public.condition_era
USING idx_condition_era_person_id;

CREATE INDEX idx_condition_era_concept_id ON public.condition_era(condition_concept_id ASC);

