SELECT
    prosrc, *
 FROM pg_proc
WHERE
    prosrc ILIKE '%parte_do_codigo_da_funcao%';
