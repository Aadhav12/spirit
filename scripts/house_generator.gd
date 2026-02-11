class_name HouseGenerator
extends Node

func generate_cell_list(house_size : int):
	var percentage_main = randi_range(70, 85)
	var house_main_size = (float(percentage_main) / 100) * house_size
	var house_offshoot_size = house_size - (float(percentage_main) / 100) * house_size
	
	var cellList : Array[Vector2i] = []
	var main_rectangle = generate_main_rectangle(house_main_size)
	for i in range(0, main_rectangle[2] + 2):
		for j in range(0, main_rectangle[3] + 2):
			cellList.append(Vector2i(main_rectangle[0] - 1 + i, main_rectangle[1] - 1 + j))
	var offshoot_rectangles = generate_offshoot_rectanges(house_offshoot_size, main_rectangle[2], main_rectangle[3])
	for rect in offshoot_rectangles:
		for i in range(0, rect[2] + 2):
			for j in range(0, rect[3] + 2):
				cellList.append(Vector2i(rect[0] - 1 + i, rect[1] - 1 + j))
	
	return cellList

func generate_furniture(cellList : Array[Vector2i], num_beds : int):
	var furniture : Array[Vector2i]
	var furniture_data = {
		"beds" : [],
		"bedside_tables" : [],
		"carpets" : [],
		"tables" : [],
		"door" : null,
	}
	
	var bedCellList = []
	for cell in cellList:
		if (Vector2i(cell.x, cell.y-1) not in cellList or Vector2i(cell.x+1, cell.y-1) not in cellList or Vector2i(cell.x-1, cell.y-1) not in cellList) and Vector2i(cell.x-1, cell.y) in cellList and Vector2i(cell.x+1, cell.y) in cellList:
			bedCellList.append(Vector2i(cell.x, cell.y+1))
		elif (Vector2i(cell.x - 1, cell.y) not in cellList) and Vector2i(cell.x, cell.y+1) in cellList and Vector2i(cell.x, cell.y-1) in cellList and Vector2i(cell.x, cell.y+2) in cellList:# or Vector2i(cell.x + 1, cel.y) not in cellList):
			bedCellList.append(Vector2i(cell.x + 1, cell.y))
		elif (Vector2i(cell.x + 1, cell.y) not in cellList) and Vector2i(cell.x, cell.y+1) in cellList and Vector2i(cell.x, cell.y-1) in cellList and Vector2i(cell.x, cell.y+2) in cellList:# or Vector2i(cell.x + 1, cel.y) not in cellList):
			bedCellList.append(Vector2i(cell.x - 1, cell.y))
	
	var cornerCellList = []
	for cell in cellList:
		if (Vector2i(cell.x-1, cell.y) not in cellList) and (Vector2i(cell.x, cell.y-1) not in cellList):
			cornerCellList.append(cell + Vector2i(1, 1))
		elif (Vector2i(cell.x+1, cell.y) not in cellList) and (Vector2i(cell.x, cell.y-1) not in cellList):
			cornerCellList.append(cell + Vector2i(-1, 1))
	var selected_cell
	var y_level : int = -1
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
		furniture_data.beds.append(selected_cell)
		furniture.append(selected_cell)
		if selected_cell in cornerCellList and selected_cell + Vector2i(1, -2) not in cellList and selected_cell + Vector2i(2, -1) not in cellList:
			furniture_data.bedside_tables.append(selected_cell+Vector2i(-1,0))
			furniture.append(selected_cell+Vector2i(-1,0))
		elif selected_cell in cornerCellList and selected_cell + Vector2i(-1, -2) not in cellList and selected_cell + Vector2i(-2, -1) not in cellList:
			furniture_data.bedside_tables.append(selected_cell+Vector2i(1,0))
			furniture.append(selected_cell+Vector2i(1,0))
		
		if selected_cell + Vector2i(0, 3) in cellList and selected_cell + Vector2i(1, 3) in cellList and selected_cell + Vector2i(-1, 3) in cellList:
			var carpet_colour = randi_range(1, 2)
			furniture_data.carpets.append(selected_cell+Vector2i(0,2))
			furniture.append(selected_cell+Vector2i(0,2))
		var toEraseList = [
			selected_cell,
			selected_cell + Vector2i(0, -1),
			selected_cell + Vector2i(0, -2),
			selected_cell + Vector2i(0, 1),
			selected_cell + Vector2i(0, 2),
			selected_cell + Vector2i(-1, 0),
			selected_cell + Vector2i(1, 0),
			selected_cell + Vector2i(1, 1),
			selected_cell + Vector2i(-1, 1),
			selected_cell + Vector2i(1, -1),
			selected_cell + Vector2i(-1, -1),
			selected_cell + Vector2i(1, -2),
			selected_cell + Vector2i(-1, -2),
		]
		for cell in toEraseList:
			while cell in bedCellList:
				bedCellList.erase(cell)
			while cell in cornerCellList:
				cornerCellList.erase(cell)
	
	var tableOptions = []
	for cell in cellList:
		var cellFree = true
		for i in range(-2, 2):
			for j in range(-1, 2):
				if cell + Vector2i(j, i) not in cellList:
					cellFree = false
				if i != -2 and cell + Vector2i(j, i) in furniture:
					cellFree = false
		if cellFree:
			tableOptions.append(cell)
	if tableOptions != []:
		var cell = tableOptions.pick_random()
		furniture_data.tables.append(cell)
		furniture.append(cell)
		furniture.append(cell + Vector2i(0, -1))
	var doorOptions = []
	for cell in cellList:
		if cell + Vector2i(0, 1) not in cellList and cell + Vector2i(1, 0) in cellList and cell + Vector2i(-1, 0) in cellList and cell + Vector2i(0, -1) not in furniture:
			doorOptions.append(cell)
	furniture_data.door = doorOptions.pick_random()
	return furniture_data

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
