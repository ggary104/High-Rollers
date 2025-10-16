extends TextureRect
func set_die(die_texture):
	if die_texture:
		self.texture = die_texture
		self.modulate = Color.WHITE # Make it fully visible
	else:
		self.texture = null
		self.modulate = Color.TRANSPARENT # Make it invisible
