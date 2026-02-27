class_name HurtComponent
extends Area2D

signal hurt

func _on_area_entered(area: Area2D) -> void:
	var attack_component = area as AttackComponent
	hurt.emit(attack_component.attack_damage)
