# import datetime
# import json

# import timezone


# class SendHistoryToBigQueryService:
#     def __init__(self, logger, publisher, topic):
#         self.logger = logger
#         self.publisher = publisher
#         self.topic = topic

#     def regist(
#         self,
#         message: str,
#     ) -> None:
#         try:
#             json_message = json.loads(message)
#             now_time = datetime.now(timezone.utc)
#             # TIMESTAMP型：Unix エポックである1970 年 1 月 1 日からの日数に変換
#             # https://cloud.google.com/pubsub/docs/bigquery?hl=ja#date_time_int
#             epoch = datetime(1970, 1, 1, tzinfo=timezone.utc)
#             elapsed_days = (now_time - epoch).days
#             json_message["update_date"] = elapsed_days
#             encoded_message = json.dumps(json_message).encode("utf-8")
#             # 送信履歴テーブル更新用Pub/Subメッセージ送信
#             future = self.publisher.publish(self.topic, encoded_message)
#             future.result()
#         except Exception as e:
#             self.logger.error("Error updating history table", e)
