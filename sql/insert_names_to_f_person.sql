INSERT INTO f_person(person_id, given1_name, family_name)
SELECT
    person_id,
    firstname,
    lastname
FROM (
    SELECT
        *
    FROM (
        SELECT
            (random() * 9 + 1) / 10 AS rn,
            person_id
        FROM
            public.person
        WHERE
            gender_concept_id = 8532) p
        JOIN (
            SELECT
                row_number() OVER () AS lastnum,
                name AS lastname
            FROM
                names.lastname) l ON round(p.rn * 88798) = l.lastnum
            JOIN (
                SELECT
                    row_number() OVER () AS firstnum,
                    name AS firstname
                FROM
                    names.female_first) f ON round(p.rn * 4274) = f.firstnum) a;

INSERT INTO f_person(person_id, given1_name, family_name)
SELECT
    person_id,
    firstname,
    lastname
FROM (
    SELECT
        *
    FROM (
        SELECT
            (random() * 9 + 1) / 10 AS rn,
            person_id
        FROM
            public.person
        WHERE
            coalesce(gender_concept_id, 0) <> 8532) p
        JOIN (
            SELECT
                row_number() OVER () AS lastnum,
                name AS lastname
            FROM
                names.lastname) l ON round(p.rn * 88798) = l.lastnum
            JOIN (
                SELECT
                    row_number() OVER () AS firstnum,
                    name AS firstname
                FROM
                    names.male_first) m ON round(p.rn * 1218) = m.firstnum) a;

