# combine-mysql-queries-without-Union
Union queries is the most used solution for combining two queries. 
It is better to use a single query method even if the structure is complex. 
As an example, when we have a table consists of thousands of rows sometimes it is enough to show the top few rows. 

CREATE TABLE trick
	(`name` varchar(7), `value` int);
	
INSERT INTO trick
	(`name`, `value`)
VALUES
	('Ahmad', 10),
	('peter', 20),
	('kevin', 30),
  ('karim', 15),
  ('andriy', 23),
  ('hoa', 17),
  ('yuzi', 19),
  ....
  ('Denika', 22);

Table with thousands number of rows:
-----------
name  value
-----------
Ahmad  10
peter  20
kevin  30
karim  15
andriy 23 
hoa    17 
yuzi   19
.....
Denika 22

Simplified table with top 5 rows and new summary row (Others) sum up the rest at the end instead:

-----------
name  value
-----------
Ahmad  10
peter  20
kevin  30
karim  15
andriy 23 
Others 6754


In case of using Union, it is easy to call two queries: 'one to get the top rows' and 'second to get the last summary row'. 
This example returns the same result but in single query without using Union:

====================================================================================
Copyright@Ahmad-Karawash
====================================================================================

set @row_number=0;
set @sumval=0;
select b.name, 
	COALESCE(b.value, b.sumvalue) AS MySummarizedValue
from( 
		select (@row_number:=@row_number + 1) AS num, 
			IFNULL(name,'others') name,
			value,
			sum(	Case 
					when @row_number<=5 
					then @sumval:=@sumval+value and null 
					else value 
					end
					) as sumvalue
		 from trick
		     
	    group by name,value
		 with rollup
  ) b
  
  where (
  			(b.value is not null and b.sumvalue is null) or (b.value is null and b.sumvalue is not null) && 
  			(b.num<5 or b.name='others')
  );
  
  

