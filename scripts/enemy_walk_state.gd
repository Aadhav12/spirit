extends NodeState

@export var sprite_2D: Sprite2D #change to animated
@export var enemy: Enemy
@export var speed: float = 25


func _physics_process(_delta: float) -> void:
	#if towers destroyed
	var player_position = enemy.player.global_position
	var target_position = (player_position - enemy.global_position).normalized()
	enemy.velocity = target_position * speed
	enemy.move_and_slide()
