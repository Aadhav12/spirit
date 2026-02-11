class_name House
extends Node2D
@warning_ignore_start("integer_division")
@export var health : int = 200
@export var base_tilemap : TileMapLayer
@export var furniture_tilemap : TileMapLayer

var house_position : Vector2i

var data : HouseData
var theme : int

func _ready():
	
	if data.theme == -1:
		theme = randi_range(0, 4)
	
	base_tilemap.set_cells_terrain_connect(data.cellList, 0, theme)
	
	for bed in data.furniture_data["beds"]:
		furniture_tilemap.set_cell(bed, theme, Vector2(0, 2))
		
	for bedside_table in data.furniture_data["bedside_tables"]:
		furniture_tilemap.set_cell(bedside_table, theme, Vector2(1, 2))
	
	for carpet in data.furniture_data["carpets"]:
		furniture_tilemap.set_cell(carpet + Vector2i(0, -1), theme, Vector2(1, 3))
		furniture_tilemap.set_cell(carpet, theme, Vector2(1, 4))
	
	for table in data.furniture_data["tables"]:
		furniture_tilemap.set_cell(table, theme, Vector2(3, 3))
		furniture_tilemap.set_cell(table + Vector2i(0, -1), theme, Vector2(4, 3))
		
	base_tilemap.set_cell(data.furniture_data["door"], theme, Vector2i(5, 2))

func draw_rectangle(rect_position: Vector2i, width: int, height: int, atlasX : int):
	for i in range(0, height):
		for j in range(0, width):
			base_tilemap.set_cell(rect_position + Vector2i(j, i), 0, Vector2i(atlasX,0))
