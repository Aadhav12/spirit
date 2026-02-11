class_name Altar
extends Node2D

@export var data : AltarData
@export var base_tilemap : TileMapLayer

@export var house_size : int
@export var num_beds : int

const house_scene = preload("res://scenes/house.tscn")
var house_instance : House
var house_generator : HouseGenerator

func _ready():
	base_tilemap.set_cells_terrain_connect(data.cellList, 0, data.school)
	house_generator = HouseGenerator.new()

func create_house():
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
	create_path(selected + house_instance.data.furniture_data.door + Vector2i(0, 1), Vector2i(2, 5))
	
	#return house_instance
	
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
	path.append(a + Vector2i(0, -1) + data.position)
	path.append(b + Vector2i(0, -1) + data.position)
	
	get_parent().set_cells_terrain_connect(path, 0, 0)
	
	for cell in path:
		get_parent().cellStatus[cell] = 1
