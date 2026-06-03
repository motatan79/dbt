with orders as (

  select * from {{ ref('int_orders') }}

),
daily as (
    select 
        order_date
        ,count(*) as orders_num
        ,{% for order_status in ['returned','completed','return_pending'] %}
            sum(case when order_status = '{{ order_status }}' then 1 else 0 end) 
            as {{ order_status }}_total {{',' if not loop.last }}
        {% endfor %}
    from orders
    group by 1
),

compared as 
(
    select 
        *
        ,lag(orders_num) over (order by order_date) as prev_day_orders
    from daily
)

select * from compared


select * from {{ ref('orders_snapshot') }} order by user_id