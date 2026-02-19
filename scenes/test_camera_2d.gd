extends Camera2D

@export var speed : float

func _process(delta):
	if Input.is_action_pressed("walk_down"):
		position.y += speed * delta
	if Input.is_action_pressed("walk_up"):
		position.y -= speed * delta
	if Input.is_action_pressed("walk_left"):
		position.x -= speed * delta
	if Input.is_action_pressed("walk_right"):
		position.x += speed * delta
