
    
    

select
    subscription_id as unique_field,
    count(*) as n_records

from default.intermediate_subscription_improved
where subscription_id is not null
group by subscription_id
having count(*) > 1


