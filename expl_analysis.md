# Commands to explore the database

I want to know if the database uses keys to link the database. Execute the following in the sql prompt to get a list of tables with the restrictions of foreign keys. 

```sql
select *
from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'FOREIGN KEY'
``

```sql
SELECT CONSTRAINT_NAME,
       UNIQUE_CONSTRAINT_NAME, 
       MATCH_OPTION, 
       UPDATE_RULE,
       DELETE_RULE,
       TABLE_NAME,
       REFERENCED_TABLE_NAME
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'iqblade'
```