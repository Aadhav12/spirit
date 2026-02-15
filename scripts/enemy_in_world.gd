extends CharacterBody2D

@export var enemy: CharacterBody2D
@export var speed: float = 25
@export var player_movement: CharacterBody2D

func _physics_process(_delta: float) -> void:
	#if towers destroyed
	var player_position = player_movement.global_position
	var target_position = (player_position - enemy.global_position).normalized()
	enemy.velocity = target_position * speed
	print("###")
	print(player_position)
	print(enemy.global_position)
	print(target_position)
	print(enemy.velocity)
	enemy.move_and_slide()
