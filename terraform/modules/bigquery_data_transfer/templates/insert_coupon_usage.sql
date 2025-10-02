MERGE INTO ${dataset}.used_coupons AS target
USING (
    SELECT user_id, coupon_code, used_at
    FROM ${dataset}.coupon_usage
    WHERE is_used = TRUE
)
AS source ON target.user_id = source.user_id
AND target.coupon_code = source.coupon_code
-- 条件に一致しなければInsertする
WHEN NOT MATCHED THEN
    INSERT (user_id, coupon_code, used_at, migrated_at)
    VALUES (source.user_id, source.coupon_code, source.used_at, CURRENT_TIMESTAMP());
