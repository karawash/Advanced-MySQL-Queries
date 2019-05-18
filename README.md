## Combine MySQL queries without Union
Union queries is the most used solution for combining two queries. 
It is better to use a single query method even if the structure is complex. 
As an example, when we have a table consists of thousands of rows sometimes it is enough to show the top few rows. <br/>

CREATE TABLE trick <br/>
	(`name` varchar(7), `value` int); <br/>
	
INSERT INTO trick <br/>
	(`name`, `value`) <br/>
VALUES <br/>
('Ahmad', 10), <br/>
('peter', 20), <br/>
('kevin', 30), <br/>
('karim', 15), <br/>
('andriy', 23), <br/>
('hoa', 17), <br/>
('yuzi', 19), <br/>
.... <br/>
('Denika', 22); <br/>
<br/>
Table with thousands number of rows: <br/>
----------- <br/>
name    value <br/>
----------- <br/>
Ahmad    10 <br/>
peter    20 <br/>
kevin    30 <br/>
karim    15 <br/>
andriy   23 <br/>
hoa      17 <br/> 
yuzi     19 <br/>
..... <br/>
Denika   22 <br/>
<br/>
Simplified table with top 5 rows and new summary row (Others) sum up the rest at the end instead: <br/>

----------- <br/>
name    value <br/>
----------- <br/>
Ahmad    10 <br/>
peter    20 <br/>
kevin    30 <br/>
karim    15 <br/>
andriy   23 <br/>
Others   6754 <br/>

<br/>
In case of using Union, it is easy to call two queries: 'one to get the top rows' and 'second to get the last summary row'. <br/>
This example returns the same result but in single query without <br/>



Copyright@Ahmad-Karawash <br/>
<br/>
set @row_number=0; <br/>
set @sumval=0; <br/>
select b.name, <br/>
COALESCE(b.value, b.sumvalue) AS MySummarizedValue <br/>
from( <br/>
select (@row_number:=@row_number + 1) AS num, <br/>
IFNULL(name,'others') name, <br/>
value,<br/>
sum(	Case <br/>
when @row_number<=5 <br/>
then @sumval:=@sumval+value and null <br/>
else value <br/>
end <br/>
) as sumvalue <br/>
from trick <br/>
group by name,value <br/>
with rollup <br/>
) b <br/>
where ( <br/>
(b.value is not null and b.sumvalue is null) or (b.value is null and b.sumvalue is not null) && <br/>
(b.num<5 or b.name='others') <br/>
); <br/>
  
  

