extends Node

@export var user_interface : Control
@export var village : Village

@export var shop_tabs : Array[ShopTabData] = []

var function_dict = {}

func _ready() -> void:
	user_interface.buy_pressed.connect(buy)
	refresh()
	function_dict = {
		"paths": village.upgrade_roads,
		"house": upgrade_paths,
		"altar": village.purchase_altar,
		"farms": upgrade_paths
	}

func buy(item_data) -> void:
	if item_data.price <= GameData.coins:
		function_dict[item_data.type].call(item_data)
		GameData.coins -= item_data.price
		user_interface.coins_label.text = str(GameData.coins)
		var tab_ref = null
		var full_item_data = null
		for tab in shop_tabs:
			if tab.name == item_data.group:
				tab_ref = tab
				tab.number_bought += 1
				break
		for item in tab_ref.tab_items:
			if item_data.name in item.names:
				full_item_data = item
				break
		if item_data.school_specific:
			full_item_data.levels[item_data.school] += 1
		else:
			full_item_data.level += 1
		refresh()

func refresh():
	GameData.shop_data = generate_shop_data()
	user_interface.shop_menu.refresh({})

func upgrade_paths(item_data):
	print(item_data)

func generate_shop_data() -> Dictionary:
	var shop_data = {}
	for tab in shop_tabs:
		if tab.school_specific:
			var tab_data = {}
			for school in GameData.purchased_schools:
				var school_data = []
				for item in tab.tab_items:
					if item.levels[school] != len(item.names):
						if tab.shared_cost:
							school_data.append({
								"name": item.names[item.levels[school]],
								"price": tab.prices[tab.number_bought],
								"type": item.type,
								"level": item.levels[school],
								"school_specific": tab.school_specific,
								"group": tab.name
							})
						else:
							school_data.append({
								"name": item.names[item.levels[school]],
								"price": item.prices[item.levels[school]],
								"type": item.type,
								"level": item.levels[school],
								"school_specific": tab.school_specific,
								"group": tab.name
							})
				tab_data[school] = school_data
			shop_data[tab.name] = tab_data
		else:
			var tab_data = []
			for item in tab.tab_items:
				if item.level != len(item.names):
					if tab.shared_cost:
						tab_data.append({
							"name": item.names[item.level],
							"price": tab.prices[tab.number_bought],
							"type": item.type,
							"level": item.level,
							"school_specific": tab.school_specific,
							"group": tab.name
						})
					else:
						tab_data.append({
							"name": item.names[item.level],
							"price": item.prices[item.level],
							"type": item.type,
							"level": item.level,
							"school_specific": tab.school_specific,
							"group": tab.name
						})
			shop_data[tab.name] = tab_data
	return shop_data
