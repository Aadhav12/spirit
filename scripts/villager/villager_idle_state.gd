extends NodeState

@onready var timer: Timer = $"../../Timer"

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	timer.start(randi_range(3, 5))


func _on_exit() -> void:
	pass


func _on_timer_timeout() -> void:
	timer.stop()
	transition.emit("Walk State")
