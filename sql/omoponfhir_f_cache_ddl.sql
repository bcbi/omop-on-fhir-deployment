CREATE TABLE f_cache(
    cache_id integer NOT NULL CONSTRAINT f_cache_pk PRIMARY KEY,
    key_text text NOT NULL,
    value_text text,
    value_int integer,
    status integer DEFAULT '-1' ::integer
);

