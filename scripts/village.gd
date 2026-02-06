extends Node2D

@export var population : int = 0
@export var house_size : int
@export var num_beds : int
const house_scene = preload("res://scenes/house.tscn")
var houses : Array[House] = []
var house_instance

func check_house_demand():
	if len(houses) < population / 4 - population % 4:
		return true
	else:
		return false

func _ready():
	pass
	#house_instance = house_scene.instantiate()
	#var percentage_main = randi_range(70, 85)
	#house_instance.house_main_size = (float(percentage_main) / 100) * house_size
	#house_instance.house_offshoot_size = house_size - (float(percentage_main) / 100) * house_size
	#house_instance.num_beds = num_beds
	#add_child(house_instance)

func _process(delta):
	if (Input.is_action_just_pressed("add_house")):
		create_house()
	if (Input.is_action_just_pressed("delete_house")):
		remove_child(house_instance)

func create_house():
	house_instance = house_scene.instantiate()
	var percentage_main = randi_range(70, 85)
	house_instance.house_main_size = (float(percentage_main) / 100) * house_size
	house_instance.house_offshoot_size = house_size - (float(percentage_main) / 100) * house_size
	house_instance.num_beds = num_beds
	add_child(house_instance)
