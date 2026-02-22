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

var coins : int = 100000

var shop_data = {}
