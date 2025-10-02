INSERT INTO `${dataset}.coupon_usage_history`
SELECT
  id,
  user_id,
  coupon_id,
  created_at,
  updated_at,
  CURRENT_TIMESTAMP() as inserted_at
FROM `${dataset}.coupon_usage`
WHERE
  created_at >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 5 MINUTE)
