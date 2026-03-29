class_name Farm
extends TileMapLayer

var school : GameData.School

func setup(farm_level : int):
	render(farm_level)

func render(farm_level : int):
	for i in range(0, 6):
		for j in range(0, 6):
			set_cell(Vector2i(i, j), school, Vector2i(7, 0) + farm_level * Vector2i(0, 4))
