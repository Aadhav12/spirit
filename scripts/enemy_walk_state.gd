extends NodeState

@export var character: CharacterBody2D
@export var sprite_2D: Sprite2D #change to animated
		
func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	#add animation
	pass
	
func _on_next_transitions() -> void:
	pass

func _on_enter() -> void:
	pass
	#play animation

func _on_exit() -> void:
	pass
	#stop animation
