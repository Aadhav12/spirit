class_name Altar
extends Node2D

@export var data : AltarData
@export var base_tilemap : TileMapLayer
@export var navigation_tilemap : TileMapLayer

const house_scene = preload("res://village/scenes/house.tscn")
const farm_scene = preload("res://village/scenes/farm.tscn")

var house_instance : House
var house_generator : HouseGenerator
var num_villagers : int = 0
var path_cells : Array[Vector2i] = []
var path_level : int = 0
@export var reputation : int = 0

var houses : Array[House]
var farms : Array[Farm]
var house_level = 0
var farm_level = 0

func _ready():
	base_tilemap.set_cells_terrain_connect(data.cellList, data.school, 0)
	base_tilemap.set_cell(data.door, data.school, Vector2i(5, 2))
	var sand_tilemap = get_parent().get_parent().get_parent().sand_tilemap
	for cell in data.cellList:
		sand_tilemap.set_cell(cell + Vector2i(global_position/32), 0, Vector2i(0, 1))
	
	for cell in data.cellList:
		if (base_tilemap.get_cell_atlas_coords(cell) == Vector2i(3, 1)):
			navigation_tilemap.set_cell(cell, data.school, Vector2i(0, 0))
	
	house_generator = HouseGenerator.new()

func _process(delta):
	if Input.is_action_just_pressed("add_altar_death"):
		reputation += 5
		print(reputation)
	if num_villagers < reputation / 5:
		if len(houses[-1].villagers) != len(houses[-1].data.furniture_data["beds"]):
			create_villager(len(houses) - 1)
		else:
			var num_beds = randi_range(1, 5)
			create_house(int(10 * num_beds), num_beds)
			create_villager(len(houses) - 1)

func create_villager(house : int):
	houses[house].create_villager(house)
	num_villagers += 1

func set_road_level(level : int):
	get_parent().upgrade_paths.set_cells_terrain_connect(path_cells, 0, level)
	path_level = level
	
func increment_road_level():
	get_parent().upgrade_paths.set_cells_terrain_connect(path_cells, 0, path_level + 1)
	path_level += 1
	
func increment_house_level():
	house_level += 1
	for house in houses:
		house.set_house_level(house_level)

func increment_farm_level():
	farm_level += 1
	for farm in farms:
		farm.render(farm_level)

func create_house(house_size : int, num_beds : int):
	var house_data = HouseData.new()
	house_instance = house_scene.instantiate()
	
	house_data.cellList = house_generator.generate_cell_list(house_size)
	house_data.furniture_data = house_generator.generate_furniture(house_data.cellList, num_beds)
	house_data.school = data.school
	
	house_instance.data = house_data
	
	var house_radius = 5
	var possible_cells = []
	var possible
	while possible_cells == []:
		for i in range(-house_radius, house_radius + 5):
			for j in range(-house_radius, house_radius + 1 + 5):
				possible = true
				for cell in house_data.cellList:
					if get_parent().cellStatus[cell + Vector2i(i, j) + data.position] != 0 or get_parent().cellStatus[cell + Vector2i(i, j+1) + data.position] != 0:
						possible = false
						break
				if possible:
					possible_cells.append(Vector2i(i, j))
		if possible_cells != []:
			break
		else:
			house_radius += 5
	var selected = possible_cells.pick_random()
	house_instance.position = selected * 32
	for cell in house_data.cellList:
		get_parent().cellStatus[selected + cell + data.position] = 2
	house_instance.data.position = selected
	add_child(house_instance)
	house_instance.render(house_level)
	create_path(selected + house_instance.data.furniture_data.door, Vector2i(2, 4))
	houses.append(house_instance)
	#return house_instance

func create_farm():
	var farm_instance = farm_scene.instantiate()
	
	var farm_radius = 5
	var possible_cells = []
	var possible
	while possible_cells == []:
		for i in range(-farm_radius, farm_radius + 6):
			for j in range(-farm_radius, farm_radius + 1 + 6):
				possible = true
				for k in range(0, 6):
					for l in range(0, 6):
						if get_parent().cellStatus[Vector2i(i+k, j+l) + data.position] != 0:
							possible = false
				if possible:
					possible_cells.append(Vector2i(i, j))
		if possible_cells != []:
			break
		else:
			farm_radius += 5
	var selected = possible_cells.pick_random()
	farm_instance.position = selected * 32
	for i in range(0, 6):
		for j in range(0, 6):
			get_parent().cellStatus[Vector2i(i, j) + selected + data.position] = 2
	farm_instance.school = data.school
	farm_instance.setup(0)
	add_child(farm_instance)
	create_path(selected + Vector2i(3, 0), Vector2i(2, 4))
	farms.append(farm_instance)

func create_path(a: Vector2i, b: Vector2i):
	var astar = AStarGrid2D.new()
	astar.region = Rect2i(-200, -200, 400, 400)
	astar.cell_size = Vector2i(1, 1)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.update()
	# Mark blocked cells
	for cell in get_parent().cellStatus:
		if astar.is_in_boundsv(cell) and get_parent().cellStatus[cell] == 2:
			astar.set_point_solid(cell, true)
		if get_parent().cellStatus[cell] == 1:
			astar.set_point_weight_scale(cell, 0.25)
	
	var path = astar.get_id_path(a + data.position, b + data.position)
	for cell in path:
		path_cells.append(cell)
	
	if path_level != 0:
		get_parent().upgrade_paths.set_cells_terrain_connect(path, 0, path_level)

	path.append(a + Vector2i(0, -1) + data.position)
	path.append(b + Vector2i(0, -1) + data.position)

	get_parent().set_cells_terrain_connect(path, 0, 0)
	
	for cell in path:
		get_parent().cellStatus[cell] = 1
