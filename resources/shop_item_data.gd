class_name ShopItemData
extends Resource

@export var names : Array[String]
@export var prices : Array[int]
@export var type : String
var level : int = 0

var levels : Dictionary = {
	GameData.School.SKY: 0,
	GameData.School.OCEAN: 0,
	GameData.School.DEATH: 0,
	GameData.School.LOVE: 0,
}
