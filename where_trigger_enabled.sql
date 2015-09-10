SELECT 
    relname AS nome_tabela, 
    tgname AS nome_trigger,  
    proname AS nome_funcao, 
    prosrc AS pl_funcao, 
    CASE 
        WHEN  tab.tgenabled = 'O' 
            THEN 'ATIVO' 
        ELSE 'DESABILITADO' 
    END
 FROM (
      pg_trigger tab
        JOIN pg_class ON (tgrelid = pg_class.oid)
        JOIN pg_proc ON (tgfoid = pg_proc.oid)
       )
WHERE tgisinternal = FALSE
 ORDER BY relname;
