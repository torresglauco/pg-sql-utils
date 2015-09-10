SELECT
    DISTINCT(c.relname), *
 FROM pg_attribute a
  JOIN pg_class c ON a.attrelid = c.oid
WHERE
 a.attname = 'nome_do_campo';   
