
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
| CloudConsultant      |          1 |      193 |
| DigitalAgency        |          1 |      257 |
| EndUser              |          1 |      728 |
| ISV                  |          1 |     1043 |
| ManagedServices      |          1 |      424 |
| MSP                  |          1 |      189 |
| Outsourcer           |          1 |      350 |
| ProfessionalServices |          1 |      162 |
| Reseller             |          1 |      619 |
| Vendor               |          1 |      276 |
+----------------------+------------+----------+


select primary_type_id, ix_twitter_account, financial_year, count(*)
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
| CloudConsultant      |                  1 |           2014 |      156 |
| CloudConsultant      |                  1 |           2015 |      165 |
| DigitalAgency        |                  1 |           2014 |      228 |
| DigitalAgency        |                  1 |           2015 |      231 |
| EndUser              |                  1 |           2014 |      656 |
| EndUser              |                  1 |           2015 |      661 |
| ISV                  |                  1 |           2014 |      836 |
| ISV                  |                  1 |           2015 |      853 |
| ManagedServices      |                  1 |           2014 |      369 |
| ManagedServices      |                  1 |           2015 |      365 |
| MSP                  |                  1 |           2014 |      172 |
| MSP                  |                  1 |           2015 |      163 |
| Outsourcer           |                  1 |           2014 |      312 |
| Outsourcer           |                  1 |           2015 |      316 |
| ProfessionalServices |                  1 |           2014 |      125 |
| ProfessionalServices |                  1 |           2015 |      130 |
| Reseller             |                  1 |           2014 |      510 |
| Reseller             |                  1 |           2015 |      502 |
| Vendor               |                  1 |           2014 |      235 |
| Vendor               |                  1 |           2015 |      205 |
+----------------------+--------------------+----------------+----------+

select primary_type_id, financial_year, count(*)
from (
select distinct a.id, a.primary_type_id, 
	case when b.id is not null then 1 else 0 end as ix_twitter_account, 
	case when length(b.description) > 0 then 1 else 0 end as ix_twitter_desc
from organisation as a
left join twitter_account as b
on a.twitter_account_id = b.id
where a.primary_type_id in ('MSP', 'Reseller', 'ISV') 
) as c 
left join organisation_year_values as b
on c.id = b.organisation_id
where financial_year in (2014,2015) and ix_twitter_account = ix_twitter_desc and 
ix_twitter_desc = 1
group by primary_type_id, ix_twitter_account, ix_twitter_desc, financial_year;

+-----------------+--------------------+-----------------+----------------+----------+
| primary_type_id | ix_twitter_account | ix_twitter_desc | financial_year | count(*) |
+-----------------+--------------------+-----------------+----------------+----------+
| ISV             |                  1 |               1 |           2014 |      836 |
| ISV             |                  1 |               1 |           2015 |      853 |
| MSP             |                  1 |               1 |           2014 |      172 |
| MSP             |                  1 |               1 |           2015 |      163 |
| Reseller        |                  1 |               1 |           2014 |      510 |
| Reseller        |                  1 |               1 |           2015 |      502 |
+-----------------+--------------------+-----------------+----------------+----------+

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
| ISV             |                  1 |               1 |     1012 |
| MSP             |                  0 |               0 |       24 |
| MSP             |                  1 |               0 |        1 |
| MSP             |                  1 |               1 |      188 |
| Reseller        |                  0 |               0 |      172 |
| Reseller        |                  1 |               0 |       32 |
| Reseller        |                  1 |               1 |      587 |
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
| ISV             |          1 |           2014 |                858 |
| ISV             |          1 |           2015 |                876 |
| MSP             |          1 |           2014 |                173 |
| MSP             |          1 |           2015 |                164 |
| Reseller        |          1 |           2014 |                537 |
| Reseller        |          1 |           2015 |                529 |
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
| ISV             |          1 |     1043 |
| MSP             |          0 |       24 |
| MSP             |          1 |      189 |
| Reseller        |          0 |      172 |
| Reseller        |          1 |      619 |
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
|          1 |           2014 |      1568 |
|          1 |           2015 |      1569 |
|          1 |           2016 |       640 |
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
|          1 |           2014 |      4022 |
|          1 |           2015 |      4007 |
|          1 |           2016 |      1741 |
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
| ISV             |           NULL |                 90 |
| ISV             |           2014 |               1015 |
| ISV             |           2015 |               1025 |
| MSP             |           NULL |                 11 |
| MSP             |           2014 |                193 |
| MSP             |           2015 |                180 |
| Reseller        |           NULL |                 75 |
| Reseller        |           2014 |                676 |
| Reseller        |           2015 |                660 |
+-----------------+----------------+--------------------+

+-----------------+----------------+--------------------+
| primary_type_id | financial_year | count(distinct id) |
+-----------------+----------------+--------------------+
| ISV             |           NULL |                 90 |
| ISV             |           2014 |               1015 |
| ISV             |           2015 |               1025 |
| ISV             |           2016 |                423 |
| MSP             |           NULL |                 11 |
| MSP             |           2014 |                193 |
| MSP             |           2015 |                180 |
| MSP             |           2016 |                 78 |
| Reseller        |           NULL |                 75 |
| Reseller        |           2014 |                676 |
| Reseller        |           2015 |                660 |
| Reseller        |           2016 |                275 |
+-----------------+----------------+--------------------+

select primary_type_id, history, count(*) 
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
group by primary_type_id, history;

+---------+----------+
| history | count(*) |
+---------+----------+
|       0 |      176 |
|       1 |      110 |
|       2 |      110 |
|       3 |      114 |
|       4 |      131 |
|       5 |      388 |
|       6 |      978 |
|       7 |      217 |
|       8 |        9 |
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
| ISV             |            0 |       90 |
| ISV             |            1 |     1139 |
| MSP             |            0 |       11 |
| MSP             |            1 |      202 |
| Reseller        |            0 |       75 |
| Reseller        |            1 |      716 |
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
| DigitalAgency        |            1 |      268 |
| EndUser              |            0 |       27 |
| EndUser              |            1 |     1078 |
| ISV                  |            0 |       90 |
| ISV                  |            1 |     1139 |
| ManagedServices      |            0 |       24 |
| ManagedServices      |            1 |      530 |
| MSP                  |            0 |       11 |
| MSP                  |            1 |      202 |
| Outsourcer           |            0 |       13 |
| Outsourcer           |            1 |      422 |
| ProfessionalServices |            0 |       18 |
| ProfessionalServices |            1 |      221 |
| Reseller             |            0 |       75 |
| Reseller             |            1 |      716 |
| Vendor               |            0 |       19 |
| Vendor               |            1 |      289 |
+----------------------+--------------+----------+


select primary_type_id, count(distinct id) 
from organisation 
where primary_type_id in ('MSP', 'Reseller', 'ISV') 
group by primary_type_id;

+-----------------+--------------------+
| primary_type_id | count(distinct id) |
+-----------------+--------------------+
| ISV             |               1229 |
| MSP             |                213 |
| Reseller        |                791 |
+-----------------+--------------------+

select count(distinct id) 
from organisation 
where primary_type_id in ('MSP', 'Reseller', 'ISV') ;

+--------------------+
| count(distinct id) |
+--------------------+
|               2233 |
+--------------------+

select count(distinct id) 
from organisation 
where primary_type_id is not null and primary_type_id <> 'Unknown';

+--------------------+
| count(distinct id) |
+--------------------+
|               5978 |
+--------------------+
