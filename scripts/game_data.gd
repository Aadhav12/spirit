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

var purchased_schools = []

var spirit_names = {
	"Tide": GameData.School.OCEAN,
	"Gravefade": GameData.School.DEATH,
	"Heartlink": GameData.School.LOVE,
	"Skypath": GameData.School.SKY,
}

var coins : int = 100000

var shop_data = {}

var house_atlas_dict = {
	"table": Vector2i(4,3),
	"chair": Vector2i(3, 3),
	"bed": Vector2i(0,2),
	"door": Vector2i(5,2),
	"bedside_table": Vector2i(1,2),
	"carpet": Vector2i(1,3),
}
