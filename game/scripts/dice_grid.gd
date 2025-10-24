class_name DiceGrid
extends Node2D


signal on_tile_selected(reference_to_tile)

var Tile := preload("res://scenes/dice_tile.tscn")
var row_size: int = 3
var tiles := []


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
	
	for tile in tiles:
		var tile_size: float = tile.size
		tile.position.x = column_number * tile_size 
		tile.position.y = row_number * tile_size
		tile.index = Vector2i(column_number, row_number)
		column_number += 1
		
		if column_number > row_size - 1:
			row_number += 1
			column_number = 0


func enable_tiles() -> void:
	for tile in tiles:
		tile.enable()


func disable_tiles() -> void:
	for tile in tiles:
		tile.disable()


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
