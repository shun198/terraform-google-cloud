import json


class SendHistoryToBigQueryService:
    def __init__(self, logger, publisher, topic_path):
        self.logger = logger
        self.publisher = publisher
        self.topic_path = topic_path

    def regist(
        self,
        message: str,
    ) -> None:
        try:
            json_message = json.loads(message)
            encoded_message = json.dumps(json_message).encode("utf-8")
            # 送信履歴テーブル更新用Pub/Subメッセージ送信
            future = self.publisher.publish(self.topic_path, encoded_message)
            future.result()
            self.logger.info("message history written inside BigQuery")
        except Exception as e:
            self.logger.error(f"Error updating history table: {e}")
