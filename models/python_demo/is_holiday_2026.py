import holidays
import pandas as pd

def model(dbt, session):

    dbt.config(
        materialized="table",
        packages=["holidays", "pandas"]
    )

    us_holidays = holidays.ARG(years=[2026])

    df = dbt.ref("calendar").to_pandas()
    df["IS_HOLIDAY"] = df["DATE_DAY"].apply(lambda date: date in us_holidays)
    
    return df