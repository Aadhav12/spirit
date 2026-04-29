class_name HealthComponent
extends Area2D

signal died

@export var HP: int = 5
@export var damage_layer: int
@export var node: Node
@export var dead: bool = false

func update_health(Amount: int) -> void:
	print("YAY IT WORKS")
	HP += Amount
	if HP <= 0:
		dead = true
		died.emit()
		print("oh no you died :(")
		
