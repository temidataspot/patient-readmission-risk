
    
    

select
    claim_id as unique_field,
    count(*) as n_records

from "ReadmitDB"."dbo"."stg_claims"
where claim_id is not null
group by claim_id
having count(*) > 1


