extends Button

var shop_menu : MarginContainer
var label_text : String

func _ready() -> void:
	text = label_text

func _on_pressed() -> void:
	shop_menu.load_category(label_text)
	shop_menu.current_slide = 0
