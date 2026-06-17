extends Button

@export var upgradeType := 0 #0 for shell, 1 for urchin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", Callable(self, "_on_pressed"))

	if upgradeType == 0:
		self.text = "Shell Upgrades"
		self.show()
	else:
		self.text = "Urchin Upgrades"
		self.hide() #urchin shop button starts hidden, only shows after player has 10 urchins AND has negative shells
	
	pass # Replace with function body.


func _on_pressed():
	#open the upgrade menu for the respective type, hide self
	self.hide()
	if upgradeType == 0:
		self.get_parent().get_node("ShellUpgrades").show()
	else:
		self.get_parent().get_node("UrchinUpgrades").show()

func _on_urchin_unlocked():
	if upgradeType == 1:
		self.show()
