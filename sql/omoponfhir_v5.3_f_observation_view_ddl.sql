CREATE VIEW f_observation_view(observation_id, person_id, observation_concept_id, observation_date, observation_datetime, observation_time, observation_type_concept_id, observation_operator_concept_id, value_as_number, value_as_string, value_as_concept_id, qualifier_concept_id, unit_concept_id, range_low, range_high, provider_id, visit_occurrence_id, observation_source_value, observation_source_concept_id, unit_source_value, value_source_value, qualifier_source_value) AS
SELECT
    measurement_id AS observation_id,
    person_id,
    measurement_concept_id AS observation_concept_id,
    measurement_date AS observation_date,
    measurement_datetime AS observation_datetime,
    measurement_time AS observation_time,
    measurement_type_concept_id AS observation_type_concept_id,
    operator_concept_id AS observation_operator_concept_id,
    value_as_number,
    NULL AS value_as_string,
    value_as_concept_id,
    NULL AS qualifier_concept_id,
    unit_concept_id,
    range_low,
    range_high,
    provider_id,
    visit_occurrence_id,
    measurement_source_value AS observation_source_value,
    measurement_source_concept_id AS observation_source_concept_id,
    unit_source_value,
    value_source_value,
    NULL AS qualifier_source_value
FROM
    public.measurement
UNION ALL
SELECT
    (- observation_id) AS observation_id,
    person_id,
    observation_concept_id,
    observation_date,
    observation_datetime,
    NULL AS observation_time,
    observation_type_concept_id,
    NULL AS observation_operator_concept_id,
    value_as_number,
    value_as_string,
    value_as_concept_id,
    qualifier_concept_id,
    unit_concept_id,
    NULL AS range_low,
    NULL AS range_high,
    provider_id,
    visit_occurrence_id,
    observation_source_value,
    observation_source_concept_id,
    unit_source_value,
    NULL AS value_source_value,
    qualifier_source_value
FROM
    public.observation;

