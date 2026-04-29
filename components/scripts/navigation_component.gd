class_name NavigationComponent
extends Area2D

@export var damage_layer: int 
@export var animated_sprite_2D: AnimatedSprite2D 
@export var character: CharacterBody2D
@export var speed: float = 100
@export var agent: NavigationAgent2D

var target_position: Vector2
var priorty_list: Array = []

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	area_entered.connect(add_to_priorty_list)
	area_exited.connect(remove_from_priorty_list)
	
func add_to_priorty_list(area: Area2D) -> void:
	if area is HealthComponent and damage_layer == area.damage_layer:
		priorty_list.append(area.node)
		area.died.connect(_on_target_died.bind(area.node))

func _on_target_died(target):
	priorty_list.erase(target)
			
func remove_from_priorty_list(area:Area2D) -> void:
	if area is HealthComponent:
		priorty_list.erase(area.node)
		
func _physics_process(_delta: float) -> void:
	
	target_position = Vector2.ZERO
	 	 	
	if len(priorty_list) > 0: 
		for target in priorty_list: 
			if target is House: 
				target_position = target.global_position 
				break

		if target_position == Vector2.ZERO: 
			for target in priorty_list: 
				if target is Player: 
					target_position = target.global_position 
					break 
	if target_position ==  Vector2.ZERO: 
		target_position = character.world.village.global_position
		
	if target_position != Vector2.ZERO:
		agent.target_position = target_position 

	if agent.is_navigation_finished():
		character.velocity = Vector2.ZERO
		character.move_and_slide()
		return

	var next_position = agent.get_next_path_position()
	character.direction = (next_position - global_position).normalized()

	if character.direction == Vector2.UP:
		animated_sprite_2D.play("walk_back")
	elif character.direction == Vector2.DOWN:
		animated_sprite_2D.play("walk_front")
	elif character.direction == Vector2.LEFT:
		animated_sprite_2D.play("walk_left")
	elif character.direction == Vector2.RIGHT:
		animated_sprite_2D.play("walk_right")
		
	character.velocity = character.direction * speed
	character.move_and_slide()
