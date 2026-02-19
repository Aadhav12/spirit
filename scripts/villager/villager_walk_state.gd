extends NodeState

@export var villager : Villager

func _on_process(_delta : float) -> void:
	if villager.agent.is_navigation_finished():
		transition.emit("Idle State")


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	if villager.current_location == GameData.VillagerLocation.HOME:
		villager.go_to(villager.village.global_position + 32*Vector2(4.5, 4.5))
		villager.current_location = GameData.VillagerLocation.TOWN_HALL
	else:
		villager.go_to(villager.house.global_position + 32*(Vector2(villager.house.data.furniture_data.door) + Vector2(0.5, -0.5)))
		villager.current_location = GameData.VillagerLocation.HOME


func _on_exit() -> void:
	pass
