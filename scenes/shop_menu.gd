extends MarginContainer

@export var item_container: HBoxContainer
@export var user_interface: Control

@export var back_button: Button
@export var next_button: Button
var shop_item_scene = preload("res://scenes/shop_item.tscn")
var current_slide = 0
var current_category = "spells"

func _ready():
	load_category("spells")
	user_interface.buy_pressed.connect(refresh)

func refresh(data):
	load_category(current_category)

func load_category(category : String):
	current_category = category
	next_button.flat = true
	back_button.flat = true
	for child in item_container.get_children():
		child.queue_free()
	for i in range(0, min(5, len(GameData.shop_data[category]))):
		var item = GameData.shop_data[category][i]
		var item_instance = shop_item_scene.instantiate()
		item_instance.setup(item)
		item_instance.user_interface = user_interface
		#item_instance.connect("buy_pressed", _on_item_bought)
		item_container.add_child(item_instance)
	if len(GameData.shop_data[category]) > 5:
		next_button.flat = false

func _on_spells_tab_pressed() -> void:
	load_category("spells")
	current_slide = 0


func _on_village_tab_pressed() -> void:
	load_category("village")
	current_slide = 0


func _on_defense_tab_pressed() -> void:
	load_category("defense")
	current_slide = 0


func _on_altar_tab_pressed() -> void:
	load_category("altars")
	current_slide = 0


func _on_back_pressed() -> void:
	if back_button.flat == false:
		next_button.flat = false
		for child in item_container.get_children():
			child.queue_free()
		current_slide -= 1
		for i in range(0, min(5, len(GameData.shop_data[current_category]) - current_slide*5)):
			var item = GameData.shop_data[current_category][i + 5*current_slide]
			var item_instance = shop_item_scene.instantiate()
			item_instance.setup(item)
			item_instance.user_interface = user_interface
			item_container.add_child(item_instance)
		if current_slide == 0:
			back_button.flat = true
			

func _on_next_pressed() -> void:
	if next_button.flat == false:
		back_button.flat = false
		for child in item_container.get_children():
			child.queue_free()
		current_slide += 1
		for i in range(0, min(5, len(GameData.shop_data[current_category]) - current_slide*5)):
			var item = GameData.shop_data[current_category][i + 5*current_slide]
			var item_instance = shop_item_scene.instantiate()
			item_instance.setup(item)
			item_instance.user_interface = user_interface
			item_container.add_child(item_instance)
		if current_slide == int(len(GameData.shop_data[current_category])/5):
			next_button.flat = true
