{% test assert_amount_is_greater_than_one( model, column_name, group_by_column) %}

    SELECT 
        {{ group_by_column }}
        ,avg( {{ column_name }}) as average_amount
    FROM {{ model }}
    GROUP BY 1
    HAVING average_amount < 1

{% endtest %}