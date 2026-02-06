class_name House
extends Node2D
@warning_ignore_start("integer_division")
@export var health : int = 200
@export var base_tilemap : TileMapLayer
@export var furniture_tilemap : TileMapLayer

var house_main_size : int = 20
var house_offshoot_size : int = 6
var cellList : Array[Vector2i]
var bedCellList : Array[Vector2i]
var house_position : Vector2i
var num_beds : int

var beds : Array[Vector2i]
var bedside_tables : Array[Vector2i]
var carpets : Array[Vector2i]
var furniture : Array[Vector2i]
var tables : Array[Vector2i]
var door : Vector2i

func _ready():
	base_tilemap.set_cells_terrain_connect(cellList, 0, 0)
	
	for bed in beds:
		furniture_tilemap.set_cell(bed, 0, Vector2(0, 2))
		
	for bedside_table in bedside_tables:
		furniture_tilemap.set_cell(bedside_table, 0, Vector2(1, 2))
	
	for carpet in carpets:
		furniture_tilemap.set_cell(carpet + Vector2i(0, -1), 0, Vector2(1, 3))
		furniture_tilemap.set_cell(carpet, 0, Vector2(1, 4))
	
	for table in tables:
		furniture_tilemap.set_cell(table, 0, Vector2(3, 3))
		furniture_tilemap.set_cell(table + Vector2i(0, -1), 0, Vector2(4, 3))
		
	base_tilemap.set_cell(door, 0, Vector2i(5, 2))

func draw_rectangle(rect_position: Vector2i, width: int, height: int, atlasX : int):
	for i in range(0, height):
		for j in range(0, width):
			base_tilemap.set_cell(rect_position + Vector2i(j, i), 0, Vector2i(atlasX,0))
