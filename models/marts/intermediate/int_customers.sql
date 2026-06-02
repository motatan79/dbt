-- Import CTEs
with customers as (

  select * from {{ ref('stg__jaffle_shop__customers') }}

),

orders as (

  select * from {{ ref('int_orders') }}

),
------------------
customer_orders as (
    select 
        orders.*
        ,customers.full_name
        ,customers.surname
        ,customers.givenname
        -- customer level aggregates
        ,min(orders.order_date) over (partition by orders.customer_id) as customer_first_order_date
        
        ,min(orders.valid_order_date) over (partition by orders.customer_id) as customer_first_non_returned_order_date
        
        ,max(orders.valid_order_date) over (partition by orders.customer_id) as customer_most_recent_non_returned_order_date
        
        ,count(*) over (partition by orders.customer_id) as customer_orders_count

        ,sum(nvl2(orders.valid_order_date, 1, 0)) over (partition by orders.customer_id) as customer_non_returned_order_count
        
        ,sum(nvl2(orders.valid_order_date, orders.order_value_dollars,0)) 
            over (partition by orders.customer_id) as customer_total_lifetime_value
        
        ,array_agg(distinct orders.order_id) over (partition by orders.customer_id) as customer_order_ids
    from orders
    inner join customers
    on orders.customer_id = customers.customer_id
),

average_customer_order_totals as (
    select 
        customer_orders.*
        ,customer_total_lifetime_value / nullif(customer_non_returned_order_count, 0) as
        customer_avg_non_returned_order_value
    from customer_orders

)

select * from average_customer_order_totals