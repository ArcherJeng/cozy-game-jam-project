extends Button

@onready var testButtonName = name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_pressed)

	if OS.is_debug_build():
		self.show()
	else:
		self.queue_free()
	pass # Replace with function body.



func _on_pressed():
	print(testButtonName," test button clicked")
	if testButtonName == "AddUrchins":
		Player.urchins += 1000
	elif testButtonName == "AddShells":
		Player.shells += 1000
	elif testButtonName == "SubtractShells":
		Player.shells -= 1000
	else:
		print("invalid test button")