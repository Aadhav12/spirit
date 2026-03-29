extends Node2D

@export var sand_tilemap: TileMapLayer
@export var village : Village

@export var school : GameData.School
@export var house : int
@export var is_child : bool
@export var user_interface : Control

const villager_scene = preload("res://characters/villager/villager.tscn")

func _ready():
	pass

func _process(delta):
	pass
