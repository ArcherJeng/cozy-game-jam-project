extends Control

var rng := RandomNumberGenerator.new()
var shellScene := preload("res://scenes/shell.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.generate_shells.connect(_on_generate_shells)
	print("Shell Generator ready, connected generate_shells signal")
	pass # Replace with function body.

func _on_generate_shells():
	#generate shells at random positions within the generator area, with a random amount of shells between 1 and 5, then emit an event to main scene to update player stats and UI
	#make sure to include the upgrade effects for shell generation, like the chance to generate extra shells or urchins 
	var maxShellCount = 2 + Player.currentShellUpgrades[1] #generate 1 shell, plus 1 more for each level of the second shell upgrade
	var shellCount = 10 #rng.randi_range(1, maxShellCount)
	print("Generating ", shellCount, " shells")
	for i in range(shellCount):
		var shell := shellScene.instantiate()
		var xPos := rng.randi_range(0, int(self.get_size().x))
		var yPos := rng.randi_range(0, int(self.get_size().y))
		self.add_child(shell)
		shell.position = Vector2(xPos, yPos)
		print("Generated shell at position: ", shell.position)
		

func _process(_delta: float) -> void:
	rng.randomize()