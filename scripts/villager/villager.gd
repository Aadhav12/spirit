class_name Villager
extends CharacterBody2D

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@export var data : VillagerData
@export var village : Village

var current_location = GameData.VillagerLocation.HOME

var speed := 100.0

var house : House
var altar : Altar

func _ready():
	altar = village.altars[data.school]
	house = village.altars[data.school].houses[data.house]
	position = Vector2(house.data.furniture_data.door)*32 + house.position + altar.position + village.position + (32 * Vector2(0, 1))

func _physics_process(delta: float) -> void:
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var next_position = agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()

	velocity = direction * speed
	move_and_slide()

func go_to(world_position: Vector2):
	agent.target_position = world_position
