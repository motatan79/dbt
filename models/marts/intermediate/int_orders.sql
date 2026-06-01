with payments as (
    select
        *
    from {{ ref('stg__stripe__payments') }}
    where payment_status <> 'fail'
),
orders as (
    select
        *
    from {{ ref('stg__jaffle_shop__orders') }}
), 



 order_totals as (
    select
        order_id
        ,payment_status
        ,sum(payment_amount) as order_value_dollars
    from payments
    group by order_id, payment_status
),

order_values_joined as (
    select
        orders.order_id
        ,orders.customer_id
        ,orders.order_date
        ,orders.valid_order_date
        ,orders.user_order_seq
        ,orders.order_status
        ,order_totals.payment_status
        ,order_totals.order_value_dollars
    from orders
    left outer join order_totals on orders.order_id = order_totals.order_id
)

select * from order_values_joined
