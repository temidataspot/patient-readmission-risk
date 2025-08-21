
    
    

select
    rx_id as unique_field,
    count(*) as n_records

from "ReadmitDB"."dbo"."stg_pharmacy"
where rx_id is not null
group by rx_id
having count(*) > 1


