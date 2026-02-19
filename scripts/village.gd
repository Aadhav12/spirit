class_name Village
extends TileMapLayer

@export var population : int = 0

const village_hall_scene = preload("res://scenes/village_hall.tscn")
const house_scene = preload("res://scenes/house.tscn")
const altar_scene = preload("res://scenes/altar.tscn")

var house_instance : House
var altar_instance : Altar
var house_generator : HouseGenerator
var cellStatus : Dictionary

var altars = {}
var astar

var houses : Array[House] = []

func _ready():
	astar = AStarGrid2D.new()
	astar.region = Rect2i(-200, -200, 400, 400)
	astar.cell_size = Vector2i(1, 1)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.update()
	for cell in cellStatus:
		if astar.is_in_boundsv(cell) and cellStatus[cell] == 2:
			astar.set_point_solid(cell, true)
		if cellStatus[cell] == 1:
			astar.set_point_weight_scale(cell, 0.25)
	
	house_generator = HouseGenerator.new()
	var village_hall_scene_instance = village_hall_scene.instantiate()
	add_child(village_hall_scene_instance)
	for i in range(-200, 200):
		for j in range(-200, 200):
			cellStatus[Vector2i(i, j)] = 0
	for i in range(0, 9):
		for j in range(0, 7):
			cellStatus[Vector2i(i, j)] = 2

func create_house(school : GameData.School, house_size : int, num_beds : int):
	if not altars.has(school):
		create_altar(school)
	altars[school].create_house(house_size, num_beds)

func create_altar(school : GameData.School):
	var altar_radius = 15
	altar_instance = altar_scene.instantiate()
	var possible_cells = []
	var possible
	while possible_cells == []:
		for i in range(-altar_radius, altar_radius + 9):
			for j in range(-altar_radius, altar_radius + 1 + 7):
				possible = true
				for k in range(-8, 13):
					for l in range(-8, 13):
						if cellStatus[Vector2i(i+k, j+l)] != 0:
							possible = false
				if possible:
					possible_cells.append(Vector2i(i, j))
		if possible_cells != []:
			break
		else:
			altar_radius += 10
	var selected = possible_cells.pick_random()
	altar_instance.position = selected * 32
	for k in range(0, 5):
		for l in range(0, 5):
			cellStatus[selected + Vector2i(k, l)] = 2
	create_path(Vector2i(4, 6), selected + Vector2i(2, 5))
	
	var altar_data = AltarData.new()
	altar_data.school = school
	altar_data.position = selected
	for i in range(0, 5):
		for j in range(0, 5):
			altar_data.cellList.append(Vector2i(i, j))
	altars[school] = altar_instance
	altar_instance.data = altar_data
	
	add_child(altar_instance)
	
func create_path(a: Vector2i, b: Vector2i):
	# Mark blocked cells
	for cell in cellStatus:
		if astar.is_in_boundsv(cell) and cellStatus[cell] == 2:
			astar.set_point_solid(cell, true)
		if cellStatus[cell] == 1:
			astar.set_point_weight_scale(cell, 0.25)
	
	var path = astar.get_id_path(a, b)
	path.append(a + Vector2i(0, -1))
	path.append(b + Vector2i(0, -1))
	
	set_cells_terrain_connect(path, 0, 0)
	
	for cell in path:
		cellStatus[cell] = 1
		
func get_village_path(a : Vector2i, b : Vector2i):
	for cell in cellStatus:
		if astar.is_in_boundsv(cell) and cellStatus[cell] == 2:
			astar.set_point_solid(cell, true)
		
		if cellStatus[cell] == 0:
			astar.set_point_weight_scale(cell, 5.0)
		
		if cellStatus[cell] == 1:
			astar.set_point_weight_scale(cell, 0.05)
	return astar.get_id_path(a, b)
	
	
