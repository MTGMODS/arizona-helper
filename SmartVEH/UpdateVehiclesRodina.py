import requests, json

# thanks arztools
url = "https://api.arztools.tech/tools/rodina/vehicles.json"
response = requests.get(url)
response.encoding = "utf-8"

data = response.json()

with open("VehiclesRodina.json", "w", encoding="cp1251") as f:
    json.dump(data, f, ensure_ascii=False, indent=4)
