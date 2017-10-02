
/* achievemets certaification */ 


SELECT 	ROUND(length(introduction), -3)    AS bucket,
       COUNT(*)                    AS COUNT,
       RPAD('', LN(COUNT(*)), '*') AS bar
FROM   organisation
where primary_type_id in ('MSP', 'Reseller', 'ISV')
GROUP BY bucket;

+--------+-------+---------+
| bucket | COUNT | bar     |
+--------+-------+---------+
|   NULL |    65 | ****    |
|      0 |   838 | ******* |
|   1000 |  1058 | ******* |
|   2000 |   226 | *****   |
|   3000 |    39 | ****    |
|   4000 |     6 | **      |
|   5000 |     6 | **      |
|   6000 |     3 | *       |
|   7000 |     4 | *       |
|  11000 |     3 | *       |
+--------+-------+---------+

/* asset base to revenue */

select primary_type_id, ix_twitter, count(*)
from (
	select primary_type_id, 
	case when twitter_account_id then 1 else 0 end as ix_twitter
	from organisation
	where primary_type_id in ('MSP','CloudConsultant','ProfessionalServices',
	'DigitalAgency','Vendor','Outsourcer','ManagedServices','Reseller',
	'EndUser','ISV') 
) as a
where ix_twitter
group by primary_type_id, ix_twitter;

+----------------------+------------+----------+
| primary_type_id      | ix_twitter | count(*) |
+----------------------+------------+----------+
| CloudConsultant      |          1 |      194 |
| DigitalAgency        |          1 |      263 |
| EndUser              |          1 |      755 |
| ISV                  |          1 |     1055 |
| ManagedServices      |          1 |      437 |
| MSP                  |          1 |      191 |
| Outsourcer           |          1 |      358 |
| ProfessionalServices |          1 |      163 |
| Reseller             |          1 |      631 |
| Vendor               |          1 |      284 |
+----------------------+------------+----------+


select primary_type_id, ix_twitter_account, financial_year, count(distinct c.id)
from (
select distinct a.id, a.primary_type_id, 
	case when b.id is not null then 1 else 0 end as ix_twitter_account, 
	case when length(b.description) > 0 then 1 else 0 end as ix_twitter_desc
from organisation as a
left join twitter_account as b
on a.twitter_account_id = b.id
where a.primary_type_id in ('MSP','CloudConsultant','ProfessionalServices',
	'DigitalAgency','Vendor','Outsourcer','ManagedServices','Reseller',
	'EndUser','ISV') 
) as c 
left join organisation_year_values as b
on c.id = b.organisation_id
where financial_year in (2014,2015) and ix_twitter_account = ix_twitter_desc and 
ix_twitter_desc = 1
group by primary_type_id, ix_twitter_account, ix_twitter_desc, financial_year;

+----------------------+--------------------+----------------+----------+
| primary_type_id      | ix_twitter_account | financial_year | count(*) |
+----------------------+--------------------+----------------+----------+
| CloudConsultant      |                  1 |           2014 |      157 |
| CloudConsultant      |                  1 |           2015 |      166 |
| DigitalAgency        |                  1 |           2014 |      232 |
| DigitalAgency        |                  1 |           2015 |      237 |
| EndUser              |                  1 |           2014 |      681 |
| EndUser              |                  1 |           2015 |      687 |
| ISV                  |                  1 |           2014 |      861 |
| ISV                  |                  1 |           2015 |      920 |
| ManagedServices      |                  1 |           2014 |      379 |
| ManagedServices      |                  1 |           2015 |      375 |
| MSP                  |                  1 |           2014 |      179 |
| MSP                  |                  1 |           2015 |      182 |
| Outsourcer           |                  1 |           2014 |      320 |
| Outsourcer           |                  1 |           2015 |      323 |
| ProfessionalServices |                  1 |           2014 |      126 |
| ProfessionalServices |                  1 |           2015 |      131 |
| Reseller             |                  1 |           2014 |      557 |
| Reseller             |                  1 |           2015 |      563 |
| Vendor               |                  1 |           2014 |      242 |
| Vendor               |                  1 |           2015 |      215 |
+----------------------+--------------------+----------------+----------+

/* If I use website introduction */

select primary_type_id, financial_year, count(*)
from (
select distinct a.id, a.primary_type_id, 
	case when b.id is not null then 1 else 0 end as ix_twitter_account, 
	case when length(a.introduction) > 0 then 1 else 0 end as ix_twitter_desc
from organisation as a
left join twitter_account as b
on a.twitter_account_id = b.id
where a.primary_type_id in ('MSP', 'Reseller', 'ISV') 
) as c 
left join organisation_year_values as b
on c.id = b.organisation_id
where financial_year in (2014,2015) and ix_twitter_desc = 1
group by primary_type_id, ix_twitter_desc, financial_year;

+-----------------+----------------+----------+
| primary_type_id | financial_year | count(*) |
+-----------------+----------------+----------+
| ISV             |           2014 |      985 |
| ISV             |           2015 |     1007 |
| MSP             |           2014 |      193 |
| MSP             |           2015 |      180 |
| Reseller        |           2014 |      659 |
| Reseller        |           2015 |      645 |
+-----------------+----------------+----------+
/* Introduction column brings more cases to be analysed */

/* If I use twitter descriptions - I WOULD USE THIS DATA! */

select primary_type_id, financial_year, ix_intro, count(*)
from (
select distinct a.id, a.primary_type_id, 
	case when length(a.introduction) > 0 then 1 else 0 end as ix_intro,
	case when b.id is not null then 1 else 0 end as ix_twitter_account, 
	case when length(b.description) > 0 then 1 else 0 end as ix_desc
from organisation as a
left join twitter_account as b
on a.twitter_account_id = b.id
where a.primary_type_id in ('MSP', 'Reseller', 'ISV') 
) as c 
left join organisation_year_values as b
on c.id = b.organisation_id
where financial_year in (2014,2015,2016) and ix_intro = 1
group by primary_type_id, financial_year, ix_intro;

+-----------------+----------------+----------+----------+
| primary_type_id | financial_year | ix_intro | count(*) |
+-----------------+----------------+----------+----------+
| ISV             |           2014 |        1 |     1013 |
| ISV             |           2015 |        1 |     1078 |
| ISV             |           2016 |        1 |      845 |
| MSP             |           2014 |        1 |      197 |
| MSP             |           2015 |        1 |      201 |
| MSP             |           2016 |        1 |      161 |
| Reseller        |           2014 |        1 |      707 |
| Reseller        |           2015 |        1 |      712 |
| Reseller        |           2016 |        1 |      617 |
+-----------------+----------------+----------+----------+


select primary_type_id, financial_year, count(*)
from (
select distinct a.id, a.primary_type_id, 
	case when length(a.introduction) > 0 then 1 else 0 end as ix_intro
	case when b.id is not null then 1 else 0 end as ix_twitter_account, 
	case when length(b.description) > 0 then 1 else 0 end as ix_twitter_desc
from organisation as a
left join twitter_account as b
on a.twitter_account_id = b.id
where a.primary_type_id in ('MSP', 'Reseller', 'ISV') 
) as c 
left join organisation_year_values as b
on c.id = b.organisation_id
where financial_year in (2014,2015) and 
ix_twitter_desc = 1
group by primary_type_id, ix_twitter_desc, financial_year;

+-----------------+----------------+----------+
| primary_type_id | financial_year | count(*) |
+-----------------+----------------+----------+
| ISV             |           2014 |      861 |
| ISV             |           2015 |      920 |
| ISV             |           2016 |      711 |
| MSP             |           2014 |      179 |
| MSP             |           2015 |      182 |
| MSP             |           2016 |      147 |
| Reseller        |           2014 |      557 |
| Reseller        |           2015 |      563 |
| Reseller        |           2016 |      485 |
+-----------------+----------------+----------+

/* Very few records in twitter history, only 26? */

select primary_type_id, ix_twitter_account, ix_twitter_desc, count(*)
from (
select distinct a.id, a.primary_type_id, 
	case when b.id is not null then 1 else 0 end as ix_twitter_account, 
	case when length(b.description) > 0 then 1 else 0 end as ix_twitter_desc
from organisation as a
left join twitter_account as b
on a.twitter_account_id = b.id
where a.primary_type_id in ('MSP', 'Reseller', 'ISV') 
) as c 
group by primary_type_id, ix_twitter_account, ix_twitter_desc;

+-----------------+--------------------+-----------------+----------+
| primary_type_id | ix_twitter_account | ix_twitter_desc | count(*) |
+-----------------+--------------------+-----------------+----------+
| ISV             |                  0 |               0 |      186 |
| ISV             |                  1 |               0 |       31 |
| ISV             |                  1 |               1 |     1024 |
| MSP             |                  0 |               0 |       22 |
| MSP             |                  1 |               0 |        1 |
| MSP             |                  1 |               1 |      190 |
| Reseller        |                  0 |               0 |      163 |
| Reseller        |                  1 |               0 |       34 |
| Reseller        |                  1 |               1 |      597 |
+-----------------+--------------------+-----------------+----------+

select primary_type_id, ix_twitter, financial_year, count(distinct id)
from (
	select distinct a.id, a.primary_type_id, b.financial_year, 
	case when twitter_account_id then 1 else 0 end as ix_twitter
	from organisation as a
	left join organisation_year_values as b
	on a.id = b.organisation_id
	where a.primary_type_id in ('MSP', 'Reseller', 'ISV') 
) as c
where (financial_year in (2014,2015)) and ix_twitter = 1
group by primary_type_id, financial_year, ix_twitter;

+-----------------+------------+----------------+--------------------+
| primary_type_id | ix_twitter | financial_year | count(distinct id) |
+-----------------+------------+----------------+--------------------+
| ISV             |          1 |           2014 |                883 |
| ISV             |          1 |           2015 |                944 |
| MSP             |          1 |           2014 |                180 |
| MSP             |          1 |           2015 |                183 |
| Reseller        |          1 |           2014 |                588 |
| Reseller        |          1 |           2015 |                593 |
+-----------------+------------+----------------+--------------------+

select primary_type_id, ix_twitter, count(*)
from (select primary_type_id, 
	case when twitter_account_id then 1 else 0 end as ix_twitter
from organisation
where primary_type_id in ('MSP', 'Reseller', 'ISV') ) as a
group by primary_type_id, ix_twitter;

+-----------------+------------+----------+
| primary_type_id | ix_twitter | count(*) |
+-----------------+------------+----------+
| ISV             |          0 |      186 |
| ISV             |          1 |     1055 |
| MSP             |          0 |       22 |
| MSP             |          1 |      191 |
| Reseller        |          0 |      163 |
| Reseller        |          1 |      631 |
+-----------------+------------+----------+

select ix_twitter, financial_year, count(distinct id) as companies
from (
	select distinct a.id, a.primary_type_id, b.financial_year, 
	case when twitter_account_id then 1 else 0 end as ix_twitter
	from organisation as a
	left join organisation_year_values as b
	on a.id = b.organisation_id
	where a.primary_type_id in ('MSP', 'Reseller', 'ISV') 
) as c
where (financial_year in (2014,2015,2016)) and ix_twitter = 1
group by financial_year, ix_twitter;

+------------+----------------+-----------+
| ix_twitter | financial_year | companies |
+------------+----------------+-----------+
|          1 |           2014 |      1651 |
|          1 |           2015 |      1720 |
|          1 |           2016 |      1396 |
+------------+----------------+-----------+

select ix_twitter, financial_year, count(distinct id) as companies
from (
	select distinct a.id, a.primary_type_id, b.financial_year, 
	case when twitter_account_id then 1 else 0 end as ix_twitter
	from organisation as a
	left join organisation_year_values as b
	on a.id = b.organisation_id
	where (a.primary_type_id is not NULL) and (a.primary_type_id <> 'Unknown')
) as c
where (financial_year in (2014,2015,2016)) and ix_twitter = 1
group by financial_year, ix_twitter;

+------------+----------------+-----------+
| ix_twitter | financial_year | companies |
+------------+----------------+-----------+
|          1 |           2014 |      4168 |
|          1 |           2015 |      4226 |
|          1 |           2016 |      2556 |
+------------+----------------+-----------+

select primary_type_id, financial_year, count(distinct id)
from (
select distinct a.id, a.primary_type_id, b.financial_year
from organisation as a
left join organisation_year_values as b
on a.id = b.organisation_id
where a.primary_type_id in ('MSP', 'Reseller', 'ISV') 
) as c
where financial_year in (2014,2015) or financial_year is NULL
group by primary_type_id, financial_year;

+-----------------+----------------+--------------------+
| primary_type_id | financial_year | count(distinct id) |
+-----------------+----------------+--------------------+
| ISV             |           NULL |                 44 |
| ISV             |           2014 |               1048 |
| ISV             |           2015 |               1114 |
| MSP             |           NULL |                  3 |
| MSP             |           2014 |                200 |
| MSP             |           2015 |                204 |
| Reseller        |           NULL |                 13 |
| Reseller        |           2014 |                733 |
| Reseller        |           2015 |                739 |
+-----------------+----------------+--------------------+

+-----------------+----------------+--------------------+
| primary_type_id | financial_year | count(distinct id) |
+-----------------+----------------+--------------------+
| ISV             |           NULL |                 44 |
| ISV             |           2014 |               1048 |
| ISV             |           2015 |               1114 |
| ISV             |           2016 |                876 |
| MSP             |           NULL |                  3 |
| MSP             |           2014 |                200 |
| MSP             |           2015 |                204 |
| MSP             |           2016 |                164 |
| Reseller        |           NULL |                 13 |
| Reseller        |           2014 |                733 |
| Reseller        |           2015 |                739 |
| Reseller        |           2016 |                644 |
+-----------------+----------------+--------------------+

select history, count(*) 
from (
	select id, primary_type_id, count(distinct financial_year) as history
from (
	select distinct a.id, a.primary_type_id, 
	(case when b.organisation_id is NOT NULL Then 1 else 0 end) as ix_financial, 
	b.financial_year
	from organisation as a
	left join organisation_year_values as b
	on a.id = b.organisation_id
	where a.primary_type_id in ('MSP', 'Reseller', 'ISV') 
) as c
	group by id
	order by count(distinct financial_year)
) as d
group by history;

+---------+----------+
| history | count(*) |
+---------+----------+
|       0 |       60 |
|       1 |      112 |
|       2 |      109 |
|       3 |      116 |
|       4 |      129 |
|       5 |      163 |
|       6 |      870 |
|       7 |      638 |
|       8 |       51 |
+---------+----------+

select c.primary_type_id, c.ix_financial, count(*) 
from ( select distinct a.id, a.primary_type_id, 
	(case when b.organisation_id is NOT NULL Then 1 else 0 end) as ix_financial
from organisation as a
left join organisation_year_values as b
on a.id = b.organisation_id
where a.primary_type_id in ('MSP', 'Reseller', 'ISV') ) as c
group by c.primary_type_id, c.ix_financial;

+-----------------+--------------+----------+
| primary_type_id | ix_financial | count(*) |
+-----------------+--------------+----------+
| ISV             |            0 |       44 |
| ISV             |            1 |     1197 |
| MSP             |            0 |        3 |
| MSP             |            1 |      210 |
| Reseller        |            0 |       13 |
| Reseller        |            1 |      781 |
+-----------------+--------------+----------+

select c.primary_type_id, c.ix_financial, count(*) 
from ( select distinct a.id, a.primary_type_id, 
	(case when b.organisation_id is NOT NULL Then 1 else 0 end) as ix_financial
from organisation as a
left join organisation_year_values as b
on a.id = b.organisation_id
where a.primary_type_id in ('MSP','CloudConsultant','ProfessionalServices',
	'DigitalAgency','Vendor','Outsourcer','ManagedServices','Reseller',
	'EndUser','ISV') ) as c
group by c.primary_type_id, c.ix_financial;

+----------------------+--------------+----------+
| primary_type_id      | ix_financial | count(*) |
+----------------------+--------------+----------+
| CloudConsultant      |            0 |       20 |
| CloudConsultant      |            1 |      201 |
| DigitalAgency        |            0 |       13 |
| DigitalAgency        |            1 |      273 |
| EndUser              |            0 |       27 |
| EndUser              |            1 |     1111 |
| ISV                  |            0 |       44 |
| ISV                  |            1 |     1197 |
| ManagedServices      |            0 |       26 |
| ManagedServices      |            1 |      537 |
| MSP                  |            0 |        3 |
| MSP                  |            1 |      210 |
| Outsourcer           |            0 |       13 |
| Outsourcer           |            1 |      423 |
| ProfessionalServices |            0 |       18 |
| ProfessionalServices |            1 |      221 |
| Reseller             |            0 |       13 |
| Reseller             |            1 |      781 |
| Vendor               |            0 |       19 |
| Vendor               |            1 |      297 |
+----------------------+--------------+----------+


select primary_type_id, count(distinct id) 
from organisation 
where primary_type_id in ('MSP', 'Reseller', 'ISV') 
group by primary_type_id;

+-----------------+--------------------+
| primary_type_id | count(distinct id) |
+-----------------+--------------------+
| ISV             |               1241 |
| MSP             |                213 |
| Reseller        |                794 |
+-----------------+--------------------+

select count(distinct id) 
from organisation 
where primary_type_id in ('MSP', 'Reseller', 'ISV') ;

+--------------------+
| count(distinct id) |
+--------------------+
|               2248 |
+--------------------+

select count(distinct id) 
from organisation 
where primary_type_id is not null and primary_type_id <> 'Unknown';

+--------------------+
| count(distinct id) |
+--------------------+
|               6055 |
+--------------------+
