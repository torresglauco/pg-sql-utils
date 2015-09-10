SELECT
    prosrc, *
 FROM pg_proc
WHERE
    proname ILIKE '%nome_da_funcao%';
