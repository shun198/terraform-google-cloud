import datetime
import hashlib
import json


class FirestoreService:
    def __init__(self, logger, collection):
        self.logger = logger
        self.collection = collection

    def if_record_exists(self, message: str) -> bool:
        """firestoreハッシュ値重複チェック

        Args:
            message (str): decoded Pub/Subメッセージ

        Returns:
            bool: 重複している場合がTrue、重複していない場合がFalse
        """
        hash_ptr = hashlib.md5(message.encode()).hexdigest()
        doc_ref = self.collection.document(hash_ptr)
        try:
            doc = doc_ref.get()
            if doc.exists:
                return True
            return False
        except Exception as e:
            self.logger.error("if record exists Error: ", e)
            return False

    def enter_single_record(self, message: str):
        """重複チェックのためにfirestoreにハッシュ値を登録する

        Args:
            message (str): decoded Pub/Subメッセージ
        """
        json_message = json.loads(message)
        try:
            hash_ptr = hashlib.md5(message.encode()).hexdigest()
            doc_ref = self.collection.document(hash_ptr)
            json_message["expireAt"] = datetime.datetime.now(
                datetime.timezone.utc
            ) + datetime.timedelta(minutes=30)
            doc_ref.set(json_message)
            self.logger.info("record inserted")
        except Exception as e:
            self.logger.error("enter single record Error: ", e)
