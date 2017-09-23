# Installation steps for mySQL in MacOSX

After installing mysql create the aliases for the commands.  Just append these lines to the `.bash_profile`

```bash
alias mysql='/usr/local/mysql/bin/mysql'
alias mysqladmin='/usr/local/mysql/bin/mysqladmin'
```

or alternatively add the whole bin to the `PATH`. 
```bash
export PATH="/usr/local/mysql/bin:$PATH"
```

Keep in mind that after installing `MySQL`, it is not launched by default. In `mac OSX`, in the preferences pane tick the box to launch the mySQL database and untick the automatic launch.  

**Note**: As of today, this is my preference.

Connect to the server, once it has been initialised with the automatic password it generated. Then, type this in `mysql` to update to a new password.

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newPass';
```

Create a new use for mysql services

```sql
CREATE USER 'custom'@'localhost' IDENTIFIED BY 'obscure';
```

To look at the default options used by `mysql`. 

```bash
$ ps aux | grep mysql
$ mysqld --verbose --help | grep -A 1 "Default options"
```

Reinitialise the complete mysql installation

```bash
mysqld --defaults-file=/opt/mysql/mysql/etc/my.cnf --initialize --user=mysql
```

And then perform an update of the password
```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newPass';
```

To start the server
```bash
mysqld_safe --user=root &
```

To stop the server
```bash
mysqladmin -u root -p shutdown
```

Just in case you need to look for the processes running the mysql server
```bash
ps aux | grep mysql
```


To check RAM in mysql 

```sql
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'innodb_additional_mem_pool_size';
SHOW VARIABLES LIKE 'innodb_log_buffer_size';
SHOW VARIABLES LIKE 'thread_stack';
SET @kilo_bytes = 1024;
SET @mega_bytes = @kilo_bytes * 1024;
SET @giga_bytes = @mega_bytes * 1024;
SET @innodb_buffer_pool_size = 2 * @giga_bytes;
SET @innodb_additional_mem_pool_size = 16 * @mega_bytes;
SET @innodb_log_buffer_size = 8 * @mega_bytes;
SET @thread_stack = 192 * @kilo_bytes;
SELECT
( @@key_buffer_size + @@query_cache_size + @@tmp_table_size
+ @innodb_buffer_pool_size + @innodb_additional_mem_pool_size
+ @innodb_log_buffer_size
+ @@max_connections * (
@@read_buffer_size + @@read_rnd_buffer_size + @@sort_buffer_size
+ @@join_buffer_size + @@binlog_cache_size + @thread_stack
) ) / @giga_bytes AS MAX_MEMORY_GB;
```

Which shows me the following
```verbatim
+---------------+
| MAX_MEMORY_GB |
+---------------+
|        2.2091 |
+---------------+
1 row in set (0.00 sec)
```

SELECT @@innodb_buffer_pool_size/1024/1024/1024;

* Optimised settings can be found [here](https://forums.mysql.com/read.php?35,561903,561903) but also can be found in the mysql [website](https://dev.mysql.com/doc/refman/5.7/en/optimize-overview.html)
* For benchmarking [here](https://dev.mysql.com/doc/refman/5.7/en/select-benchmarking.html)
* To add new users [click here](https://dev.mysql.com/doc/refman/5.7/en/adding-users.html)

First configuration I tried

```bash
[mysqld]
user = root
datadir = /Users/alfredogarbuno/github-repos/iqblade/sql-files/data
join_buffer_size = 32M
read_rnd_buffer_size = 32M
innodb_buffer_pool_size = 1536M
innodb_file_per_table = 1
innodb_file_format = barracuda
max_heap_table_size=256M
tmp_table_size=256M
max_connections = 20 
```

```
+---------------+
| MAX_MEMORY_GB |
+---------------+
|        3.5438 |
+---------------+
```

```sql
mysql> SELECT BENCHMARK(100000000,1+1);
+--------------------------+
| BENCHMARK(100000000,1+1) |
+--------------------------+
|                        0 |
+--------------------------+
1 row in set (1.46 sec)
```

Following the overall recommendations [here](https://www.percona.com/blog/2014/01/28/10-mysql-performance-tuning-settings-after-installation/) here is my conf file 

```bash
[mysqld]
user = root
datadir = /Users/alfredogarbuno/github-repos/iqblade/sql-files/data
general_log = 1
general_log_file = /Users/alfredogarbuno/github-repos/iqblade/sql-files/data/logquery.log
join_buffer_size = 256M
read_rnd_buffer_size = 128M
innodb_buffer_pool_size = 11G
innodb_log_file_size = 512M
innodb_file_per_table = 1
innodb_file_format = barracuda
max_heap_table_size=256M
tmp_table_size=256M
max_connections = 20 
query_cache_size = 0
expire_logs_days = 5
```
