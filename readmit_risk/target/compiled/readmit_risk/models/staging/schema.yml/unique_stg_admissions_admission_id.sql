
    
    

select
    admission_id as unique_field,
    count(*) as n_records

from "ReadmitDB"."dbo"."stg_admissions"
where admission_id is not null
group by admission_id
having count(*) > 1


