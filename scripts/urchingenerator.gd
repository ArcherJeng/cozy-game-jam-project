extends Control

var urchinScene := preload("res://scenes/urchin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.generate_urchins.connect(_on_generate_urchins)

func _on_generate_urchins():
	#generate urchins at random positions within the generator area, with a random amount of urchins between 1 and 5, then emit an event to main scene to update player stats and UI
	#make sure to include the upgrade effects for urchin generation, like the chance to generate extra urchins or shells
	var maxUrchinCount = 2 + Player.currentUrchinUpgrades[0] + Player.currentShellUpgrades[3] #generate 1 urchin, plus 1 more for each level of the second urchin upgrade
	var urchinCount = randi_range(max(1,maxUrchinCount-2), maxUrchinCount)
	for i in range(urchinCount):
		var urchin := urchinScene.instantiate()
		var xPos := randf_range(0, self.get_size().x)
		var yPos := randf_range(0, self.get_size().y)
		self.add_child(urchin)
		urchin.position = Vector2(xPos, yPos)
		

