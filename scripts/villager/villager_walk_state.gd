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
	var next_location = GameData.VillagerLocation.values().pick_random()
	if next_location == GameData.VillagerLocation.HOME:
		villager.go_to(villager.altar.global_position + 32*Vector2(2.5, 3.5))
		villager.current_location = GameData.VillagerLocation.ALTAR
	elif next_location == GameData.VillagerLocation.ALTAR:
		villager.go_to(villager.village.global_position + 32*Vector2(4.5, 4.5))
		villager.current_location = GameData.VillagerLocation.TOWN_HALL
	else:
		var destinations = []
		for cell in villager.house.data.cellList:
			if villager.house.navigation_tilemap.get_cell_atlas_coords(cell) == Vector2i(0, 0):
				destinations.append(Vector2(cell))
		villager.go_to(villager.house.global_position + 32*destinations.pick_random() + 32*Vector2(0.5, 0.5))
		villager.current_location = GameData.VillagerLocation.HOME
	villager.data.speed = randi_range(50, 150)


func _on_exit() -> void:
	pass
