extends Button

var shop_menu : MarginContainer
var label_text : String

func _ready() -> void:
	text = label_text

func _on_pressed() -> void:
	if GameData.purchased_schools == []:
		shop_menu.load_category(label_text, GameData.School.NONE)
	else:
		shop_menu.load_category(label_text, GameData.purchased_schools[0])
	shop_menu.current_slide = 0
