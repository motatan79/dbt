-- Import CTEs
with customer_orders as (
    select 
        *
    from {{ ref('int_customers') }}
),

------------------

-- Final CTE
final as (
    select 
        order_id,
        customer_id,
        surname,
        givenname,
        customer_first_order_date as first_order_date,
        customer_orders_count as order_count,
        customer_total_lifetime_value as total_lifetime_value,
        customer_avg_non_returned_order_value,
        order_value_dollars,
        order_status,
        payment_status

    from customer_orders
)

-- Simple Select Statment
select * from final