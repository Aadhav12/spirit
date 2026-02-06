class_name House
extends Node2D
@warning_ignore_start("integer_division")
@export var health : int = 200
@export var base_tilemap : TileMapLayer
@export var furniture_tilemap : TileMapLayer

var house_main_size : int = 20
var house_offshoot_size : int = 6
var rectangles : Array[Array] = [[0,0,7,5], [7,0,3,2]]
var house_position : Vector2
var num_beds : int

func _ready():
	#for rectangle in rectangles:
		#draw_rectangle(Vector2(rectangle[0], rectangle[1]), rectangle[2], rectangle[3])
	var cellList = []
	var main_rectangle = generate_main_rectangle(house_main_size)
	for i in range(0, main_rectangle[2] + 2):
		for j in range(0, main_rectangle[3] + 2):
			cellList.append(Vector2(main_rectangle[0] - 1 + i, main_rectangle[1] - 1 + j))
	var offshoot_rectangles = generate_offshoot_rectanges(house_offshoot_size, main_rectangle[2], main_rectangle[3])
	for rect in offshoot_rectangles:
		for i in range(0, rect[2] + 2):
			for j in range(0, rect[3] + 2):
				cellList.append(Vector2(rect[0] - 1 + i, rect[1] - 1 + j))
	base_tilemap.set_cells_terrain_connect(cellList, 0, 0)
	var bedCellList = []
	for cell in cellList:
		if (Vector2(cell.x, cell.y-1) not in cellList or Vector2(cell.x+1, cell.y-1) not in cellList or Vector2(cell.x-1, cell.y-1) not in cellList) and Vector2(cell.x-1, cell.y) in cellList and Vector2(cell.x+1, cell.y) in cellList:
			bedCellList.append(Vector2(cell.x, cell.y+1))
		elif (Vector2(cell.x - 1, cell.y) not in cellList) and Vector2(cell.x, cell.y+1) in cellList and Vector2(cell.x, cell.y-1) in cellList and Vector2(cell.x, cell.y+2) in cellList:# or Vector2(cell.x + 1, cel.y) not in cellList):
			bedCellList.append(Vector2(cell.x + 1, cell.y))
		elif (Vector2(cell.x + 1, cell.y) not in cellList) and Vector2(cell.x, cell.y+1) in cellList and Vector2(cell.x, cell.y-1) in cellList and Vector2(cell.x, cell.y+2) in cellList:# or Vector2(cell.x + 1, cel.y) not in cellList):
			bedCellList.append(Vector2(cell.x - 1, cell.y))
	var cornerCellList = []
	for cell in cellList:
		if (Vector2(cell.x-1, cell.y) not in cellList) and (Vector2(cell.x, cell.y-1) not in cellList):
			cornerCellList.append(cell + Vector2(1, 1))
		elif (Vector2(cell.x+1, cell.y) not in cellList) and (Vector2(cell.x, cell.y-1) not in cellList):
			cornerCellList.append(cell + Vector2(-1, 1))
	var selected_cell
	var y_level
	var y_list
	for i in range(0, num_beds):
		if bedCellList == []:
			break
		if cornerCellList != []:
			y_list = []
			for cell in cornerCellList:
				if cell.y == y_level:
					y_list.append(cell)
			if y_list == []:
				selected_cell = cornerCellList.pick_random()
			else:
				selected_cell = y_list.pick_random()				
		else:
			y_list = []
			for cell in cornerCellList:
				if cell.y == y_level:
					y_list.append(cell)
			if y_list == []:
				selected_cell = bedCellList.pick_random()
			else:
				selected_cell = y_list.pick_random()	
		y_level = selected_cell.y
		furniture_tilemap.set_cell(selected_cell, 0, Vector2(0,2))
		var toEraseList = [
			selected_cell,
			selected_cell + Vector2(0, -1),
			selected_cell + Vector2(0, -2),
			selected_cell + Vector2(0, 1),
			selected_cell + Vector2(0, 2),
			selected_cell + Vector2(-1, 0),
			selected_cell + Vector2(1, 0),
			selected_cell + Vector2(1, 1),
			selected_cell + Vector2(-1, 1),
			selected_cell + Vector2(1, -1),
			selected_cell + Vector2(-1, -1),
		]
		for cell in toEraseList:
			while cell in bedCellList:
				bedCellList.erase(cell)
			while cell in cornerCellList:
				cornerCellList.erase(cell)

func draw_rectangle(rect_position: Vector2, width: int, height: int, atlasX : int):
	for i in range(0, height):
		for j in range(0, width):
			base_tilemap.set_cell(rect_position + Vector2(j, i), 0, Vector2(atlasX,0))

func generate_main_rectangle(size : int):
	var width = -1
	var height = 1
	
	while 0.5 >= float(width)/float(height) or float(width)/float(height) >= 2:
		width = randi_range(1, int(size ** 0.5) + 1)
		height = max(1, int(size / width))
	if randi_range(0, 1) == 1:
		var temp = height
		height = width
		width = temp
	
	return [0, 0, width, height]

func generate_offshoot_rectanges(size : int, main_width : int, main_height : int):
	if size / 6 == 0:
		return [[0,0,0,0]]
	var num_rectangles = 1
	var rectangle_size = size / num_rectangles
	var offshoot_rectangles = []
	for i in range(0, num_rectangles):
		var width = -1
		var height = 1
		var x = 0
		var y = 0
		while 0.5 >= float(width)/float(height) or float(width)/float(height) >= 2:
			width = randi_range(1, int(rectangle_size ** 0.5) + 1)
			height = max(1, int(size / width))
		if randi_range(0, 1) == 1:
			var temp = height
			height = width
			width = temp
		var attach = -1
		if width > height:
			attach = randi_range(2, 3)
		else:
			attach = randi_range(0, 1)
		match attach:
			0: #top
				x = randi_range(0, main_width - width)
				y = -height
			1: #bottom
				x = randi_range(0, main_width - width)
				y = main_height
			2: #left
				x = -width
				y = randi_range(0, main_height - height)
			3: #right
				x = main_width
				y = randi_range(0, main_height - height)
		offshoot_rectangles.append([x, y, width, height])
	return offshoot_rectangles
