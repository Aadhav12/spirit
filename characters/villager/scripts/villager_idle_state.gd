extends NodeState

@onready var timer: Timer = $"../../Timer"
@export var agent : NavigationAgent2D

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	timer.start(randi_range(5, 10))


func _on_exit() -> void:
	pass

func _on_timer_timeout() -> void:
	timer.stop()
	transition.emit("Walk State")
