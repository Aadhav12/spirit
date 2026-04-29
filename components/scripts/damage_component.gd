class_name DamageComponent
extends Area2D

@export var attack_damage: int = -1
@export var damage_layer: int 
@export var force: float
@export var time: float

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	area_entered.connect(damage)
	
func damage(area: Area2D) -> void:
	if area is HealthComponent and damage_layer == area.damage_layer:
		area.update_health(attack_damage)
	if area is KnockbackComponent and damage_layer == area.damage_layer:
		var knockback_direction = (area.global_position - global_position).normalized()
		area.apply_knockback(knockback_direction, force, time)
