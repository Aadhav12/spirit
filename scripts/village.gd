extends TileMapLayer

@export var population : int = 0
@export var size : int = 30
@export var beds : int = 3
@export var theme : int = 0

const village_hall_scene = preload("res://scenes/village_hall.tscn")
const house_scene = preload("res://scenes/house.tscn")
const altar_scene = preload("res://scenes/altar.tscn")

var house_instance : House
var altar_instance
var house_generator : HouseGenerator

var houses : Array[House] = []
var cellsUsed : Array[Vector2i]
var pathCells : Array[Vector2i]

func check_house_demand():
	if len(houses) < population / 4 - population % 4:
		return true
	else:
		return false

func _ready():
	house_generator = HouseGenerator.new()
	var village_hall_scene_instance = village_hall_scene.instantiate()
	add_child(village_hall_scene_instance)
	for i in range(0, 9):
		for j in range(0, 7):
			cellsUsed.append(Vector2i(i, j))

func _process(delta):
	if (Input.is_action_just_pressed("add_house")):
		house_instance = create_house(beds, size, Vector2i(0,0))
		add_child(house_instance)
		
	if (Input.is_action_just_pressed("add_altar")):
		add_child(create_altar())
	
	if (Input.is_action_just_pressed("delete_house")):
		for cell in house_instance.data.cellList:
			cellsUsed.erase(cell)
		house_instance.queue_free()

func create_altar():
	var altar_radius = 15
	altar_instance = altar_scene.instantiate()
	var possible_cells = []
	var possible
	for i in range(-altar_radius, altar_radius + 1):
		for j in range(-altar_radius, altar_radius + 1):
			possible = true
			for k in range(-5, 10):
				for l in range(-5, 10):
					if Vector2i(i + k, j + l) in cellsUsed:
						possible = false
			if possible:
				possible_cells.append(Vector2i(i, j))
	var selected = possible_cells.pick_random()
	altar_instance.position = selected * 32
	for k in range(0, 5):
		for l in range(0, 5):
			cellsUsed.append(selected + Vector2i(k, l))
	create_path(Vector2i(4, 7), selected + Vector2i(2, 5))
	return altar_instance
	
func create_path(a: Vector2i, b: Vector2i):
	var astar = AStarGrid2D.new()
	astar.region = Rect2i(-200, -200, 400, 400)
	astar.cell_size = Vector2i(1, 1)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	# Mark blocked cells
	for cell in cellsUsed:
		if astar.is_in_boundsv(cell) and cell not in pathCells:
			astar.set_point_solid(cell, true)
	
	var path = astar.get_id_path(a, b)
	path.append(a + Vector2i(0, -1))
	path.append(b + Vector2i(0, -1))
	
	set_cells_terrain_connect(path, 0, 0)
	
	for cell in path:
		#set_cell(cell, 1, Vector2i(0,0))
		cellsUsed.append(cell)
		pathCells.append(cell)
	
func create_house(num_beds : int, house_size : int, house_position : Vector2i):
	var data = HouseData.new()
	house_instance = house_scene.instantiate()
	
	data.cellList = house_generator.generate_cell_list(house_size)
	data.furniture_data = house_generator.generate_furniture(data.cellList, num_beds)
	data.theme = theme
	
	house_instance.data = data
	
	for cell in data.cellList:
		if(cell not in cellsUsed):
			cellsUsed.append(cell + house_position)
	
	return house_instance
