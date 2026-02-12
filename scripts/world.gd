extends Node2D

@export var village : Village

func _ready():
	village.create_house(GameData.School.SKY, 40, 5)
	village.create_house(GameData.School.SKY, 15, 1)
	village.create_house(GameData.School.SKY, 20, 2)
	village.create_house(GameData.School.SKY, 30, 3)
	
	village.create_house(GameData.School.OCEAN, 15, 1)
	village.create_house(GameData.School.OCEAN, 15, 1)
	village.create_house(GameData.School.OCEAN, 15, 1)
	village.create_house(GameData.School.OCEAN, 20, 2)
	village.create_house(GameData.School.OCEAN, 20, 2)
	
	village.create_house(GameData.School.DEATH, 30, 3)
	village.create_house(GameData.School.DEATH, 30, 3)
	village.create_house(GameData.School.DEATH, 40, 5)
	
	village.create_house(GameData.School.LOVE, 20, 2)
	village.create_house(GameData.School.LOVE, 20, 2)
	village.create_house(GameData.School.LOVE, 20, 2)
	village.create_house(GameData.School.LOVE, 20, 2)
	village.create_house(GameData.School.LOVE, 20, 2)
