class_name DiceGrid
extends Node2D


signal on_tile_selected(reference_to_tile: DiceTile)

var Tile := preload("res://scenes/dice_tile.tscn")
var row_size: int = 3
var arranged_tiles := []
var unarranged_tiles := []
var is_enabled: bool = false


func _ready() -> void:
	spawn_tiles(row_size)
	arrange_tiles()
	print_tiles()


func spawn_tiles(number_of_tiles: int) -> void:
	var i: int = 0
	
	while i in range(number_of_tiles ** 2):
		var tile: DiceTile = Tile.instantiate()
		add_child(tile)
		tile.selected.connect(tile_selected)
		i += 1
	
	unarranged_tiles = self.get_children()


func arrange_tiles() -> void:
	var row_number: int = 0
	var column_number: int = 0
	
	for tile: DiceTile in unarranged_tiles:
		var tile_size: float = tile.size
		tile.position.x = column_number * tile_size 
		tile.position.y = row_number * tile_size
		if column_number == 0:
			arranged_tiles.append([])
		
		arranged_tiles[row_number].append(tile)
		tile.index = Vector2i(column_number, row_number)
		column_number += 1
		
		if column_number > row_size - 1:
			row_number += 1
			column_number = 0


func enable_tiles() -> void:
	if is_enabled:
		return
	
	for tile: DiceTile in unarranged_tiles:
		tile.enable()
		is_enabled = true


func disable_tiles() -> void:
	if not is_enabled:
		return
	
	for tile: DiceTile in unarranged_tiles:
		tile.disable()
		is_enabled = false


func select_tile(tile_index: Vector2i) -> void:
	var tile: DiceTile = arranged_tiles[tile_index.y][tile_index.x]
	tile.select()


func get_tile(tile_index: Vector2i) -> DiceTile:
	var tile: DiceTile = arranged_tiles[tile_index.y][tile_index.x]
	return tile


#func get_tile_number_from_index(tile_index: Vector2i) -> int:
	#var row_number: int = tile_index.y
	#var column_number: int = tile_index.x
	#var tile_number: int = column_number + (row_number * row_size)
	#
	#return tile_number


func tile_selected(reference_to_tile: DiceTile) -> void:
	on_tile_selected.emit(reference_to_tile)


func get_grid_score() -> int:
	var dice_grid: Array = get_grid_dice()
	var row: int = 0
	var column: int = 0
	var score_total: int = 0
	
	var dice: Dice = null
	
	var dice_in_row: Array = []
	while row < row_size:
		
		if is_instance_valid(dice_grid[row][column]):
			dice = dice_grid[row][column]
			var dice_score: int = dice.get_score_value()
			dice_in_row.append(dice_score)
			dice_score *= dice_in_row.count(dice_score)
			if is_dice_2_in_column(dice_grid, column):
				dice_score *= 2
			
			score_total += dice_score
		
		
		column += 1
		if column < row_size:
			continue
		
		
		row += 1
		dice_in_row.clear()
		column = 0 
	
	return score_total


func is_dice_2_in_column(dice_grid: Array, column: int) -> bool:
	for row: Array in dice_grid:
		
		if not is_instance_valid(row[column]):
			continue
		
		var dice: Dice = row[column]
		
		var dice_score: int = dice.get_score_value()
		
		if dice_score == 2:
			return true
	
	return false


func get_grid_dice() -> Array:
	var grid_dice: Array = []
	var row: int = 0
	var column: int = 0
	
	for tile: DiceTile in unarranged_tiles:
		if column == 0:
			grid_dice.append([])
		
		var dice: Dice = tile.dice
		
		grid_dice[row].append(dice)
		
		column += 1
		if column >= row_size:
			column = 0
			row += 1 
	
	return grid_dice


# Helper funciton to calculate the average dice value of grid
func get_grid_average() -> float:
	var total_sum: int = 0
	var count: int = 0
	for tile: DiceTile in unarranged_tiles:
		if is_instance_valid(tile.dice):
			# Use the face val to calculate average -> To use Dice 6 as 6
			total_sum += tile.dice.face_value
			count += 1
	
	if count == 0:
		return 0.0
	
	return float(total_sum) / float(count)


func set_dice_6_score() -> void:
	var adjusted_6_value: int = get_adjusted_6_value()
	
	for tile: DiceTile in unarranged_tiles:
		if not is_instance_valid(tile.dice):
			continue
		
		var tile_dice: Dice = tile.dice
		if tile_dice.face_value == 6:
			tile_dice.score_value = adjusted_6_value


func get_adjusted_6_value() -> int:
	var average: float = get_grid_average()
	var diff: float = average - 3.5 
	# For every 0.5 -> Value changes by one wether -ve or +ve
	var adjusted_value: int = round(diff / 0.5) 
	var temp_score_value: int = 6 + adjusted_value #new value of 6
	
	if temp_score_value < 1: 
		temp_score_value = 1
		
	return temp_score_value


func clear() -> void:
	var list_of_tiles: Array = self.get_children()
	for tile: DiceTile in list_of_tiles:
		var tile_dice: Dice = tile.dice
		if not tile_dice == null:
			tile_dice.destroy()
			tile.dice = null
		tile.enable()


func is_full() -> bool:
	for tile: DiceTile in unarranged_tiles:
		if tile.dice == null:
			return false
	
	return true


func print_tiles() -> void:
	for row: Array in arranged_tiles:
		print_row(row)


func print_row(row: Array) -> void:
	var row_scores := []
	for tile: DiceTile in row:
		var score: int = tile.get_dice_score()
		row_scores.append(score)
	
	print(row_scores)
