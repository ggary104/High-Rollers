extends TextureRect
func set_die(die_texture):
	if die_texture:
		self.texture = die_texture
	else:
		self.texture = null
