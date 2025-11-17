class_name DiceGrid
extends Node2D


signal on_tile_selected(reference_to_tile: DiceTile)

var Tile := preload("res://scenes/dice_tile.tscn")
var row_size: int = 3
var tiles := []
var is_enabled: bool = false


func _ready() -> void:
	spawn_tiles(row_size ** 2)
	arrange_tiles()


func spawn_tiles(number_of_tiles: int) -> void:
	var i: int = 0
	
	while i in range(number_of_tiles):
		var tile: DiceTile = Tile.instantiate()
		add_child(tile)
		tile.selected.connect(tile_selected)
		i += 1
	
	tiles = self.get_children() 


func arrange_tiles() -> void:
	var row_number: int = 0
	var column_number: int = 0
	
	for tile: DiceTile in tiles:
		var tile_size: float = tile.size
		tile.position.x = column_number * tile_size 
		tile.position.y = row_number * tile_size
		tile.index = Vector2i(column_number, row_number)
		column_number += 1
		
		if column_number > row_size - 1:
			row_number += 1
			column_number = 0


func enable_tiles() -> void:
	if is_enabled:
		return
	
	for tile: DiceTile in tiles:
		tile.enable()
		is_enabled = true


func disable_tiles() -> void:
	if not is_enabled:
		return
	
	for tile: DiceTile in tiles:
		tile.disable()
		is_enabled = false


func select_tile(tile_index: Vector2i) -> void:
	var tile_number = get_tile_number_from_index(tile_index)
	var tile = tiles[tile_number]
	tile.select()


func get_tile(tile_index: Vector2i) -> DiceTile:
	var tile_number: int = get_tile_number_from_index(tile_index)
	var tile = tiles[tile_number]
	return tile


func get_tile_number_from_index(tile_index: Vector2i) -> int:
	var row_number: int = tile_index.y
	var column_number: int = tile_index.x
	var tile_number: int = column_number + (row_number * row_size)
	
	return tile_number


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
		print(Vector2(row, column))
		
		if is_instance_valid(dice_grid[row][column]):
			dice = dice_grid[row][column]
			var dice_score: int = dice.get_score_value()
			dice_in_row.append(dice_score)
			dice_score *= dice_in_row.count(dice_score)
			if is_dice_2_in_column(dice_grid, column):
				dice_score *= 2
				dice_score -= 2
			
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
	
	for tile: DiceTile in tiles:
		if column == 0:
			grid_dice.append([])
		
		var dice: Dice = tile.dice
		print(dice)
		
		grid_dice[row].append(dice)
		
		column += 1
		if column >= row_size:
			column = 0
			row += 1 
	
	return grid_dice


func clear() -> void:
	for tile: DiceTile in tiles:
		var tile_dice: Dice = tile.dice
		if not tile_dice == null:
			tile_dice.destroy()
			tile.dice = null
		tile.enable()


func is_full() -> bool:
	for tile: DiceTile in tiles:
		if tile.dice == null:
			return false
	
	return true
