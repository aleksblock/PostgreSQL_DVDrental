-- 1. С помощью SQL-запроса выведите названия ограничений первичных ключей.
select tc.table_name as "Название таблицы",
       tc.constraint_name as "Название ограничения",
       kc.column_name as "Название колонки"
from   information_schema.table_constraints tc
       inner join information_schema.key_column_usage kc on tc.constraint_name = kc.constraint_name  
where 
       tc.constraint_schema = 'public' and 
       tc.constraint_type = 'PRIMARY KEY' 
     
     
     
    








      
    
    


