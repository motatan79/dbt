----------------------------------------------------------------
-- Compare Row Counts
---------------------------------------------------------------

{% set old_relation = adapter.get_relation(
      database = "target.database",
      schema = "dbt_moises2",
      identifier = "fct_customer_orders"
) -%}

{% set dbt_relation = ref('customer_orders_legacy') %}

{{ audit_helper.compare_row_counts(
    a_relation = old_relation,
    b_relation = dbt_relation
) }}

----------------------------------------------------------------
-- Compare Columns Values
---------------------------------------------------------------

{% set old_relation = adapter.get_relation(
      database = "target.database",
      schema = "dbt_moises2",
      identifier = "fct_orders"
) -%}

{% set dbt_relation = ref('fct_orders') %}

{{ audit_helper.compare_all_columns(
    a_relation = old_relation,
    b_relation = dbt_relation,
    primary_key = "order_id"
) }}

