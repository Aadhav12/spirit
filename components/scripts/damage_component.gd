extends Area2D

@export var attack_damage: int = -1
@export var damage_layer: int 

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	area_entered.connect(damage)
	
func damage(area: Area2D) -> void:
	if area is HealthComponent and damage_layer == area.damage_layer:
		area.update_health(attack_damage)
