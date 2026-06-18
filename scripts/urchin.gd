extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.pressed.connect(_on_pressed)
	pass # Replace with function body.


# 1. on click, send an event, then delete self

func _on_pressed():
	#send event, confirm event is received in main scene, then play sound and delete self
	Player.emit_signal("urchin_pressed") #send pos to do a +shellamt animation in main scene
	print("urchin pressed at: ", self.position.x, self.position.y)

	#sound effect for shell press and popup text here

	self.get_parent().queue_free()
