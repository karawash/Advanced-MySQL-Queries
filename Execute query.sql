
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