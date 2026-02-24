extends MarginContainer

@export var item_container: HBoxContainer
@export var user_interface: Control

@export var back_button: Button
@export var next_button: Button
@export var tab_container: HBoxContainer
@export var school_selector: HBoxContainer
@export var school_selector_container: HBoxContainer

@export var normal_school_icon_resource: IconData
@export var hover_school_icon_resource: IconData
@export var pressed_school_icon_resource: IconData

const tab_button_scene = preload("res://scenes/tab_button.tscn")
const shop_item_scene = preload("res://scenes/shop_item.tscn")
const school_button_scene = preload("res://scenes/shop_school_button.tscn")

var current_slide = 0
var current_category = "Spells"
var current_school = GameData.School.NONE
var current_category_school_specific = false
var button_group : ButtonGroup

func _ready():
	load_category("Spells", GameData.School.NONE)
	user_interface.buy_pressed.connect(refresh)
	for key in GameData.shop_data:
		var tab_button_instance = tab_button_scene.instantiate()
		tab_button_instance.label_text = key
		tab_button_instance.shop_menu = self
		tab_container.add_child(tab_button_instance)

func refresh(data):
	load_category(current_category, current_school)

func load_category(category : String, school : GameData.School):
	current_category = category
	current_school = school
	next_button.flat = true
	back_button.flat = true
	for child in item_container.get_children():
		child.queue_free()
	if GameData.shop_data[category] is Dictionary:
		current_category_school_specific = true
		school_selector_container.visible = true
		add_school_selector()
		if GameData.shop_data[category].has(school):
			for i in range(0, min(5, len(GameData.shop_data[category][school]))):
				var item = GameData.shop_data[category][school][i]
				var item_instance = shop_item_scene.instantiate()
				item_instance.setup(item)
				item_instance.user_interface = user_interface
				item_container.add_child(item_instance)
	else:
		school_selector_container.visible = false
		current_category_school_specific = false
		for i in range(0, min(5, len(GameData.shop_data[category]))):
			var item = GameData.shop_data[category][i]
			var item_instance = shop_item_scene.instantiate()
			item_instance.setup(item)
			item_instance.user_interface = user_interface
			item_container.add_child(item_instance)
	if len(GameData.shop_data[category]) > 5:
		next_button.flat = false

func add_school_selector():
	var school_button_instance
	button_group = ButtonGroup.new()
	for child in school_selector.get_children():
		child.queue_free()
	var first = true
	for school in GameData.purchased_schools:
		school_button_instance = school_button_scene.instantiate()
		if first and current_school == GameData.School.NONE:
			school_button_instance.button_pressed = true
			first = false
		if school == current_school:
			school_button_instance.button_pressed = true
		school_button_instance.add_theme_icon_override("checked", pressed_school_icon_resource.textures[school])
		school_button_instance.add_theme_icon_override("unchecked", normal_school_icon_resource.textures[school])
		school_button_instance.add_theme_icon_override("normal", normal_school_icon_resource.textures[school])
		school_button_instance.add_theme_icon_override("hover", hover_school_icon_resource.textures[school])
		school_button_instance.add_theme_icon_override("pressed", pressed_school_icon_resource.textures[school])
		school_button_instance.button_group = button_group
		school_button_instance.shop_menu = self
		school_button_instance.label = school
		for style in ["normal", "hover", "pressed", "checked", "unchecked"]:
			var sb = school_button_instance.get_theme_stylebox(style)
			sb = sb.duplicate()  # VERY IMPORTANT
			sb.content_margin_left = 0
			sb.content_margin_top = 0
			sb.content_margin_right = 0
			sb.content_margin_bottom = 0
			school_button_instance.add_theme_stylebox_override(style, sb)
			school_button_instance.set_meta("school", school)
		school_selector.add_child(school_button_instance)

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
