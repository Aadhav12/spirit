extends NodeState

@export var animated_sprite_2D: AnimatedSprite2D 
@export var enemy: Enemy
@export var speed: float = 150
@export var agent: NavigationAgent2D

func _physics_process(_delta: float) -> void:
	#if towers destroyed
	var player_position = enemy.player.global_position
	agent.target_position = player_position
	
	if agent.is_navigation_finished():
		enemy.velocity = Vector2.ZERO
		enemy.move_and_slide()
		return

	var next_position = agent.get_next_path_position()
	var direction = (next_position - enemy.global_position).normalized()
	
	if direction == Vector2.UP:
		animated_sprite_2D.play("walk_back")
	elif direction == Vector2.DOWN:
		animated_sprite_2D.play("walk_front")
	elif direction == Vector2.LEFT:
		animated_sprite_2D.play("walk_left")
	elif direction == Vector2.RIGHT:
		animated_sprite_2D.play("walk_right")
	
	enemy.velocity = direction * speed
	enemy.move_and_slide()
