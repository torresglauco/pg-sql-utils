SELECT 
    c1.relname AS tabela, 
    c2.relname AS indice,
    c2.relpages * 8 AS tamanho_kb, 
    c2.relfilenode AS arquivo
 FROM pg_class c1, pg_class c2, pg_index i
WHERE
     c1.oid = i.indrelid AND
     i.indexrelid = c2.oid
  UNION
SELECT relname, 
       NULL, 
       relpages * 8, relfilenode
 FROM pg_class
WHERE
     relkind = 'r'
      ORDER BY tabela, indice DESC, tamanho_kb;
