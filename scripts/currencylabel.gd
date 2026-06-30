extends RichTextLabel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.text = "Shells: " + str(Player.shells)
	if Player.urchins_unlocked_bool == true:
		self.text += "\n[color=ff0000]Urchins: " + str(Player.urchins) + "[/color]"
