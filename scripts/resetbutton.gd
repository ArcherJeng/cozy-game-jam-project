extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_press)


func _on_press():
	Player.emit_signal("resetsave")
