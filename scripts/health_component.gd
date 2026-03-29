class_name HealthComponent
extends Area2D

@export var HP: int = 5
@export var damage_layer: int
	
func update_health(Amount: int) -> void:
	print("YAY IT WORKS")
	HP += Amount
	if HP <= 0:
		print("oh no you died:(")
