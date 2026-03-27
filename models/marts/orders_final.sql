{{ config(
    materialized='incremental'
) }}

select
    o.order_id,
    c.customer_name,
    o.amount,
    o.order_date
from {{ ref('stg_orders') }} o
join {{ ref('stg_customers') }} c
    on o.customer_id = c.customer_id

{% if is_incremental() %}
where o.order_date > (select max(order_date) from {{ this }})
{% endif %}