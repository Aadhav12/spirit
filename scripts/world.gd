extends Node2D

@export var village : Village

@export var school : GameData.School
@export var house : int
@export var is_child : bool

const villager_scene = preload("res://scenes/villager.tscn")

func _ready():
	village.create_house(GameData.School.SKY, 20, 2)
	village.create_house(GameData.School.SKY, 20, 2)
	village.create_house(GameData.School.SKY, 15, 1)
	village.create_house(GameData.School.SKY, 40, 5)
	
	village.create_house(GameData.School.OCEAN, 30, 3)
	
	
	var villager_instance = villager_scene.instantiate()
	var villager_data = VillagerData.new()
	villager_data.school = school
	villager_data.house = house
	villager_data.is_child = is_child
	villager_instance.data = villager_data
	villager_instance.village = village
	add_child(villager_instance)
