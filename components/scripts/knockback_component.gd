class_name KnockbackComponent
extends Area2D

@export var character: CharacterBody2D
@export var damage_layer: int

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0 

func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		character.velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
		character.move_and_slide()

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
