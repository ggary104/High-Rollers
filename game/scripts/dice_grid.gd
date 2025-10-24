class_name DiceGrid
extends Node2D


signal on_tile_selected(reference_to_tile)

var Tile := preload("res://scenes/dice_tile.tscn")
var row_size: int = 3
var tiles_in_order := []


func _ready() -> void:
	spawn_tiles(row_size ** 2)
	arrange_tiles()


func spawn_tiles(number_of_tiles) -> void:
	var i: int = 0
	
	while i in range(number_of_tiles):
		var tile:DiceTile = Tile.instantiate()
		add_child(tile)
		tile.selected.connect(tile_selected)
		i += 1
	
	tiles_in_order = self.get_children() 


func arrange_tiles() -> void:
	var tiles: Array = tiles_in_order
	var row_number: int = 1
	var column_number: int = 1
	
	for tile in tiles:
		var tile_size = tile.size
		tile.position.x = (column_number -1) * tile_size 
		tile.position.y = (row_number -1) * tile_size
		tile.index = Vector2(column_number, row_number)
		column_number += 1
		
		if column_number > row_size:
			row_number += 1
			column_number = 1


func enable_tiles() -> void:
	var tiles: Array = tiles_in_order
	for tile in tiles:
		tile.enable()


func disable_tiles() -> void:
	var tiles: Array = tiles_in_order
	for tile in tiles:
		tile.disable()


func select_tile(tile_index) -> void:
	var tile = tiles_in_order[tile_index.y][tile_index.x]
	tile.select()


func get_tile(dice_number) -> DiceTile:
	var tile = tiles_in_order[dice_number-1]
	return tile


func tile_selected(reference_to_tile) -> void:
	on_tile_selected.emit(reference_to_tile)
