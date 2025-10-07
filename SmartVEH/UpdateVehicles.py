import requests
import json

url = "https://api.arztools.tech/tools/arizona/vehicles.json"
response = requests.get(url)
response.encoding = "utf-8"

data = response.json()

with open("Vehicles.json", "w", encoding="cp1251") as f:
    json.dump(data, f, ensure_ascii=False, indent=4)
