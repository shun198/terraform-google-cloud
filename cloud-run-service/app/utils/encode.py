import base64
import json

js = {
    "data": "Hello",
}
text = json.dumps(js, ensure_ascii=False)
print(base64.b64encode(text.encode("utf-8")).decode("utf-8"))
