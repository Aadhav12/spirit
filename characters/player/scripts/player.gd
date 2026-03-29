class_name Player
extends CharacterBody2D

var player_direction: Vector2

@export var hurt_component: HurtComponent 
@export var health_component: HealthComponent 

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	health_component.max_damage_reached.connect(on_max_damage_reached)
	
func on_hurt(hit_damage: int) -> void:
	health_component.apply_damage(hit_damage)
	
func on_max_damage_reached() -> void:
	print("Max damage reached!")
	queue_free()
