extends Area2D

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	area_entered.connect(attack)
	
func attack(body: Node2D) -> void:
	if area is HealthComponent and damage_layer == area.damage_layer:
		
