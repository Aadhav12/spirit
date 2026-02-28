extends CheckButton

var shop_menu : MarginContainer
var label : GameData.School


func _on_pressed() -> void:
	shop_menu.load_category(shop_menu.current_category, label)
