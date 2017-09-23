# Commands to explore the database

I want to know if the database uses keys to link the database. Execute the following in the sql prompt to get a list of tables with the restrictions of foreign keys. 

```sql
select *
from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE = 'FOREIGN KEY';
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
WHERE CONSTRAINT_SCHEMA = 'iqblade';
```

To get the parent child relations use this query 

```sql
SELECT
  ke.referenced_table_name parent,
  ke.table_name child,
  ke.constraint_name
FROM
  information_schema.KEY_COLUMN_USAGE ke
WHERE
  ke.referenced_table_name IS NOT NULL
ORDER BY
  ke.referenced_table_name;
```

And to get the parent-child relations with the the `keys` used just query this:

```sql
SELECT
    table_name AS 'parent',
    column_name as 'link',
    referenced_table_name as 'child', 
    referenced_column_name as 'linkc'
FROM
    information_schema.key_column_usage
WHERE
    referenced_table_name IS NOT NULL
AND 
    table_schema = 'iqblade';
```

```sql
SELECT table_name, table_rows     
FROM INFORMATION_SCHEMA.TABLES     
WHERE TABLE_SCHEMA = 'iqblade' 
ORDER BY table_rows;
```

```SQL
SELECT table_name, table_rows     
FROM INFORMATION_SCHEMA.TABLES     
WHERE TABLE_SCHEMA = 'iqblade' AND table_rows = 0;
```