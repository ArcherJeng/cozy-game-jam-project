extends Button

@export var upgradeType := 0 #0 for shell, 1 for urchin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_pressed)
	Player.urchins_unlocked.connect(_on_urchin_unlocked)

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

func _process(_delta: float) -> void:
	if !Player.urchins_unlocked_bool && upgradeType == 1:
		self.hide()
