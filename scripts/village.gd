extends TileMapLayer

@export var population : int = 0
@export var size : int = 30
@export var beds : int = 3
@export var theme : int = 0

var radius : int = 10
const house_scene = preload("res://scenes/house.tscn")
var houses : Array[House] = []
var house_instance : House
var cellsUsed : Array[Vector2i]
var house_generator : HouseGenerator

func check_house_demand():
	if len(houses) < population / 4 - population % 4:
		return true
	else:
		return false

func _ready():
	house_generator = HouseGenerator.new()

func _process(delta):
	if (Input.is_action_just_pressed("add_house")):
		house_instance = create_house(beds, size, Vector2i(0,0))
		add_child(house_instance)
	
	if (Input.is_action_just_pressed("delete_house")):
		for cell in house_instance.data.cellList:
			cellsUsed.erase(cell)
		house_instance.queue_free()

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
