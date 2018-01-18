require('byebug')
require('json')
file = File.open("gironde.json")
gironde = JSON.parse(file.read)
file.close
file = File.open("communes-20160119.json")
@communes = JSON.parse file.read
file.close
def correct_nom(nom)
  [
    ["Val-de-Virvée","Val de Virvée"],
  ].each do |real_name,wrong_name|
    nom = real_name if nom == wrong_name
  end
  nom
end
def fetch_surf(nom)
  res = 0
  nom = correct_nom(nom)
  @communes["features"].each do |commune|
    if (commune["properties"]["nom"] == nom || commune["properties"]["nom"] == "Le #{nom}" || commune["properties"]["nom"] == "La #{nom}" || commune["properties"]["nom"] == "Les #{nom}")
      res = commune["properties"]["surf_ha"]
    end
  end
  res
end
@i = 0
jsons = []
gironde["features"].each do |villejson|
  @i += 1
  newjson = villejson
  nom = villejson["properties"]["nom"]
  jsons.push(fetch_surf(nom))
  puts @i
end
@i = 0
byebug
gironde["features"].each do |ville|
  ville["properties"]["surf_ha"] = jsons[@i]
  @i += 1
end

file = File.open("gironde_completed.json","wb")
file.write(gironde.to_json)
file.close
