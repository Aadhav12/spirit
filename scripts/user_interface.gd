extends Control

signal buy_pressed(item)

@export var shop_menu: Control
@export var hud: Control
@export var coins_label: Label

func _ready():
	shop_menu.visible = false
	hud.visible = true
	coins_label.text = str(GameData.coins)

func _on_close_pressed() -> void:
	shop_menu.visible = false
	hud.visible = true

func reduce_coins(value : int):
	GameData.coins -= value
	coins_label.text = str(GameData.coins)
	
func add_coins(value : int):
	GameData.coins += value
	coins_label.text = str(GameData.coins)

func _on_open_shop_pressed() -> void:
	shop_menu.visible = true
	hud.visible = false
