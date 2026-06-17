extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", Callable(self, "_on_pressed"))
	pass # Replace with function body.


# 1. on click, send an event, then delete self

func _on_pressed():
	#send event, confirm event is received in main scene, then play sound and delete self
	Player.emit_signal("shell_pressed") #send pos to do a +shellamt animation in main scene
	print("shell pressed at: ", self.position.x, self.position.y)

	#sound effect for shell press and popup text here

	self.get_parent().queue_free()
