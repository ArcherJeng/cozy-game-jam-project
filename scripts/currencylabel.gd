extends RichTextLabel
var urchins_unlocked_bool := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.urchins_unlocked.connect(_on_urchin_unlocked)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.text = "Shells: " + str(Player.shells)
	if urchins_unlocked_bool == true:
		self.text += "\n[color=00ff00]Urchins: " + str(Player.urchins) + "[/color]"

func _on_urchin_unlocked():
	urchins_unlocked_bool = true
