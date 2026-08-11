# ============================================================
# CUSTOMER INTELLIGENCE PROJECT
# MACHINE LEARNING - REPEAT PURCHASE PREDICTION
# ============================================================

from pathlib import Path

import pandas as pd

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (
    accuracy_score,
    confusion_matrix,
    classification_report
)


# ============================================================
# 1. PROJECT PATHS
# ============================================================

BASE_DIR = Path(__file__).resolve().parent.parent

DATA_DIR = BASE_DIR / "data"
OUTPUT_DIR = BASE_DIR / "output"

# Create output folder automatically if it does not exist
OUTPUT_DIR.mkdir(exist_ok=True)


# ============================================================
# 2. LOAD DATA
# ============================================================

orders = pd.read_csv(
    DATA_DIR / "olist_orders_dataset.csv"
)

order_items = pd.read_csv(
    DATA_DIR / "olist_order_items_dataset.csv"
)

customers = pd.read_csv(
    DATA_DIR / "olist_customers_dataset.csv"
)


# ============================================================
# 3. CONVERT DATE COLUMN
# ============================================================

orders["order_purchase_timestamp"] = pd.to_datetime(
    orders["order_purchase_timestamp"]
)


# ============================================================
# 4. CHOOSE CUTOFF DATE
# ============================================================

cutoff_date = pd.Timestamp("2018-07-01")


# ============================================================
# 5. DIVIDE DATA INTO PAST AND FUTURE
# ============================================================

past_orders = orders[
    orders["order_purchase_timestamp"] < cutoff_date
].copy()

future_orders = orders[
    orders["order_purchase_timestamp"] >= cutoff_date
].copy()


print("Past orders:", len(past_orders))
print("Future orders:", len(future_orders))


# ============================================================
# 6. CONNECT PAST ORDERS WITH CUSTOMER UNIQUE ID
# ============================================================

past_orders = past_orders.merge(
    customers[
        [
            "customer_id",
            "customer_unique_id"
        ]
    ],
    on="customer_id",
    how="left"
)


# ============================================================
# 7. ADD ORDER VALUE
# ============================================================

order_items["order_value"] = (
    order_items["price"]
    +
    order_items["freight_value"]
)


# ============================================================
# 8. MERGE PAST ORDERS WITH ORDER ITEMS
# ============================================================

past_customer_data = past_orders.merge(
    order_items[
        [
            "order_id",
            "order_value"
        ]
    ],
    on="order_id",
    how="inner"
)


# ============================================================
# 9. CREATE RFM FEATURES FROM PAST DATA
# ============================================================

rfm_data = (
    past_customer_data
    .groupby(
        "customer_unique_id",
        as_index=False
    )
    .agg(
        last_purchase=(
            "order_purchase_timestamp",
            "max"
        ),

        frequency=(
            "order_id",
            "nunique"
        ),

        monetary=(
            "order_value",
            "sum"
        )
    )
)


# ============================================================
# 10. CREATE RECENCY
# ============================================================

rfm_data["recency"] = (
    cutoff_date
    -
    rfm_data["last_purchase"]
).dt.days


# ============================================================
# 11. FIND CUSTOMERS WHO PURCHASED IN FUTURE
# ============================================================

future_customers = future_orders.merge(
    customers[
        [
            "customer_id",
            "customer_unique_id"
        ]
    ],
    on="customer_id",
    how="left"
)


future_customer_ids = (
    future_customers[
        "customer_unique_id"
    ]
    .dropna()
    .unique()
)


# ============================================================
# 12. CREATE TARGET: BUY AGAIN
# ============================================================

rfm_data["buy_again"] = (
    rfm_data["customer_unique_id"]
    .isin(future_customer_ids)
    .astype(int)
)


# ============================================================
# 13. CHECK TARGET DISTRIBUTION
# ============================================================

print("\nBuy Again Distribution:")

print(
    rfm_data["buy_again"]
    .value_counts()
)

print("\nPercentage:")

print(
    rfm_data["buy_again"]
    .value_counts(normalize=True)
    .mul(100)
    .round(2)
)


# ============================================================
# 14. DEFINE FEATURES X AND TARGET y
# ============================================================

X = rfm_data[
    [
        "recency",
        "frequency",
        "monetary"
    ]
]

y = rfm_data["buy_again"]


# ============================================================
# 15. TRAIN / TEST SPLIT
# ============================================================

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    random_state=42,
    stratify=y
)


# ============================================================
# 16. STANDARDIZE FEATURES
# ============================================================

scaler = StandardScaler()

X_train_scaled = scaler.fit_transform(
    X_train
)

X_test_scaled = scaler.transform(
    X_test
)


# ============================================================
# 17. CREATE LOGISTIC REGRESSION MODEL
# ============================================================

model = LogisticRegression(
    class_weight="balanced",
    max_iter=1000,
    random_state=42
)


# ============================================================
# 18. TRAIN MODEL
# ============================================================

model.fit(
    X_train_scaled,
    y_train
)


# ============================================================
# 19. MAKE PREDICTIONS
# ============================================================

y_pred = model.predict(
    X_test_scaled
)


# ============================================================
# 20. PREDICT PURCHASE PROBABILITY
# ============================================================

y_probability = model.predict_proba(
    X_test_scaled
)[:, 1]


# ============================================================
# 21. MODEL EVALUATION
# ============================================================

accuracy = accuracy_score(
    y_test,
    y_pred
)

print(
    "\nModel Accuracy:",
    round(accuracy * 100, 2),
    "%"
)


print("\nConfusion Matrix:")

print(
    confusion_matrix(
        y_test,
        y_pred
    )
)


print("\nClassification Report:")

print(
    classification_report(
        y_test,
        y_pred,
        zero_division=0
    )
)


# ============================================================
# 22. CREATE FINAL CUSTOMER PREDICTION TABLE
# ============================================================

results = rfm_data.loc[
    X_test.index,
    [
        "customer_unique_id",
        "recency",
        "frequency",
        "monetary"
    ]
].copy()


results["actual_buy_again"] = (
    y_test.values
)

results["predicted_buy_again"] = (
    y_pred
)

results["buy_again_probability"] = (
    y_probability
)


# ============================================================
# 23. CONVERT PROBABILITY TO PERCENTAGE
# ============================================================

results[
    "buy_again_probability_pct"
] = (
    results["buy_again_probability"]
    * 100
).round(2)


# ============================================================
# 24. CREATE CUSTOMER PREDICTION SEGMENTS
# ============================================================

results["prediction_segment"] = pd.cut(
    results["buy_again_probability"],
    bins=[
        0,
        0.40,
        0.70,
        1.00
    ],
    labels=[
        "Low Probability",
        "Medium Probability",
        "High Probability"
    ],
    include_lowest=True
)


# ============================================================
# 25. SORT HIGH-PROBABILITY CUSTOMERS FIRST
# ============================================================

results = results.sort_values(
    "buy_again_probability",
    ascending=False
)


# ============================================================
# 26. EXPORT RFM DATA
# ============================================================

rfm_data.to_csv(
    OUTPUT_DIR / "ml_customer_rfm.csv",
    index=False
)


# ============================================================
# 27. EXPORT PREDICTIONS FOR POWER BI
# ============================================================

results.to_csv(
    OUTPUT_DIR / "customer_predictions.csv",
    index=False
)


print(
    "\nCustomer predictions exported successfully!"
)

print(
    "File:",
    OUTPUT_DIR / "customer_predictions.csv"
)


# ============================================================
# 28. PREVIEW RESULTS
# ============================================================

print("\nTop Prediction Results:")

print(
    results.head(10)
)

