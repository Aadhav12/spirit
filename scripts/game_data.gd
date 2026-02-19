extends Node

enum School {
	NONE,
	SKY,
	OCEAN,
	DEATH,
	LOVE
}

enum VillagerLocation {
	HOME,
	ALTAR,
	TOWN_HALL
}

var spirit_names = {
	"Tide": GameData.School.OCEAN,
	"Gravefade": GameData.School.DEATH,
	"Heartlink": GameData.School.LOVE,
	"Skypath": GameData.School.SKY,
}

const AltarCosts = [0, 500, 1500, 4000, 9000, 15000, 21000, 28000, 36000, 45000, 55000]


var coins : int = 6000

var shop_data = {
	"spells" : [
		{"name": "Fireball", "type": "spell", "price": "100"},
		{"name": "Eagle", "type": "spell", "price": "200"},
	],
	"village" : [
		{"name": "Roads II", "type": "village", "price": "500"},
		{"name": "Furniture III", "type": "village", "price": "200"},
		{"name": "Farms I", "type": "village", "price": "200"},
		{"name": "Decor I", "type": "village", "price": "200"},
	],
	"defense" : [
		{"name": "Wall IV", "type": "defense", "price": "1000"},
		{"name": "Melee", "type": "defense", "price": "500"},
		{"name": "Ranged", "type": "defense", "price": "500"},
	],
	"altars" : [
		{"name": "Tide", "type": "altar", "price": "0"},
		{"name": "Skypath", "type": "altar", "price": "0"},
		{"name": "Gravefade", "type": "altar", "price": "0"},
		{"name": "Heartlink", "type": "altar", "price": "0"},
		{"name": "Wildgrowth", "type": "altar", "price": "0"},
		{"name": "Sunflare", "type": "altar", "price": "0"},
		{"name": "Firepulse", "type": "altar", "price": "0"},
		{"name": "Nightveil", "type": "altar", "price": "0"},
		{"name": "Illusion", "type": "altar", "price": "0"},
		{"name": "Frost", "type": "altar", "price": "0"},
		{"name": "Stormweave", "type": "altar", "price": "0"},
	],
}
