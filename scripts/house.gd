class_name House
extends Node2D
@warning_ignore_start("integer_division")
@export var health : int = 200
@export var base_tilemap : TileMapLayer
@export var furniture_tilemap : TileMapLayer
@export var navigation_tilemap : TileMapLayer
@export var health_component: HealthComponent

var villagers : Array[Villager] = []

const villager_scene = preload("res://scenes/villager.tscn")

var house_position : Vector2i

var data : HouseData
var school : GameData.School


func _ready():
	school = data.school
	create_health_hitbox()

func set_house_level(house_level : int):
	render(house_level)

func render(house_level : int):
	var sand_tilemap = get_parent().get_parent().get_parent().get_parent().sand_tilemap
	
	for cell in data.cellList:
		sand_tilemap.set_cell(cell + Vector2i(global_position/32), 0, Vector2i(0, 1))
	
	base_tilemap.set_cells_terrain_connect(data.cellList, school, house_level)
	
	for bed in data.furniture_data["beds"]:
		furniture_tilemap.set_cell(bed, school, house_level*Vector2i(0, 4) + GameData.house_atlas_dict["bed"])
		
	for bedside_table in data.furniture_data["bedside_tables"]:
		furniture_tilemap.set_cell(bedside_table, school, house_level*Vector2i(0, 4) + GameData.house_atlas_dict["bedside_table"])
	
	for carpet in data.furniture_data["carpets"]:
		furniture_tilemap.set_cell(carpet + Vector2i(0, -1), school, house_level*Vector2i(0, 4) + GameData.house_atlas_dict["carpet"])
		furniture_tilemap.set_cell(carpet, school, house_level*Vector2i(0, 4) + GameData.house_atlas_dict["carpet"] + Vector2i(0, 1))
	
	for table in data.furniture_data["tables"]:
		furniture_tilemap.set_cell(table, school, house_level*Vector2i(0, 4) + GameData.house_atlas_dict["table"])
		furniture_tilemap.set_cell(table + Vector2i(0, -1), school, house_level*Vector2i(0, 4) + GameData.house_atlas_dict["chair"])
		
	base_tilemap.set_cell(data.furniture_data["door"], school, house_level*Vector2i(0, 4) + GameData.house_atlas_dict["door"])
	for cell in data.cellList:
		if (cell not in data.furniture_data["tables"]
		and cell not in data.furniture_data["bedside_tables"]
		and cell not in data.furniture_data["beds"]
		and cell != data.furniture_data.door
		and cell + Vector2i(0, 1) not in data.furniture_data["beds"]
		and cell + Vector2i(0, 1) not in data.furniture_data["tables"]
		and base_tilemap.get_cell_atlas_coords(cell) == Vector2i(3, 1)):
			navigation_tilemap.set_cell(cell, school, Vector2i(0, 0))

func create_villager(house : int):
	var villager_instance = villager_scene.instantiate()
	var villager_data = VillagerData.new()
	villager_data.school = data.school
	villager_data.house = house
	villager_data.is_child = false
	villager_instance.data = villager_data
	villager_instance.village = get_parent().get_parent()
	get_parent().get_parent().get_parent().add_child(villager_instance)
	villagers.append(villager_instance)

func draw_rectangle(rect_position: Vector2i, width: int, height: int, atlasX : int):
	for i in range(0, height):
		for j in range(0, width):
			base_tilemap.set_cell(rect_position + Vector2i(j, i), 0, Vector2i(atlasX,0))

func create_health_hitbox():
	for cell in data.cellList:
		
		var collision = CollisionShape2D.new()
		
		var rect = RectangleShape2D.new()
		rect.size = Vector2(32, 32)
		
		collision.shape = rect
		collision.position = cell * 32
		
		collision.position = Vector2(cell) * 32 + Vector2(16, 16)
		
		health_component.add_child(collision)
