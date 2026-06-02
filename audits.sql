----------------------------------------------------------------
-- Compare Row Counts
---------------------------------------------------------------

{% set old_relation = adapter.get_relation(
      database = "ANALYTICS",
      schema = "DBT_MOISES2",
      identifier = "customer_orders_legacy"
) -%}

{% set dbt_relation = ref('fct_customer_orders') %}

{{ audit_helper.compare_row_counts(
    a_relation = old_relation,
    b_relation = dbt_relation
) }}

----------------------------------------------------------------
-- Compare Columns Values
---------------------------------------------------------------

{% set old_relation = adapter.get_relation(
      database = "ANALYTICS",
      schema = "DBT_MOISES2",
      identifier = "CUSTOMER_ORDERS_LEGACY"
) -%}

{% set dbt_relation = ref('fct_customer_orders') %}

{% if execute %}
{{ audit_helper.compare_all_columns(
    a_relation = old_relation,
    b_relation = dbt_relation,
    primary_key = "order_id"
) }}
{% endif %}

