extends Control

var shellScene := preload("res://scenes/shell.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.generate_shells.connect(_on_generate_shells)
	pass # Replace with function body.

func _on_generate_shells():
	#generate shells at random positions within the generator area, with a random amount of shells between 1 and 5, then emit an event to main scene to update player stats and UI
	#make sure to include the upgrade effects for shell generation, like the chance to generate extra shells or urchins 
	var maxShellCount = 2 + Player.currentShellUpgrades[0] + Player.currentUrchinUpgrades[3] #generate 1 shell, plus 1 more for each level of the second shell upgrade
	var shellCount = randi_range(max(1,maxShellCount-2), maxShellCount)
	for i in range(shellCount):
		var shell := shellScene.instantiate()
		var xPos := randf_range(0, self.get_size().x)
		var yPos := randf_range(0, self.get_size().y)
		self.add_child(shell)
		shell.position = Vector2(xPos, yPos)
		
