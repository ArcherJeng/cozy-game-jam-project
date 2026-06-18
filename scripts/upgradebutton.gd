extends Button


@export var upgradeType := 0 #0 for shell, 1 for urchin
@export var upgradeIndex := 0 #index of the upgrade in the respective array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_on_upg_button_pressed)
	Player.on_upg_bought.connect(_on_update_cost)

func _on_upg_button_pressed():
	print("Upgrade button pressed for upgrade type: ", upgradeType, " and index: ", upgradeIndex)
	if upgradeType == 0:
		if Player.shells >= Player.getUpgradeCost(upgradeType, upgradeIndex):
			Player.emit_signal("buy_upgrade", upgradeType, upgradeIndex) #send event to main scene to update player stats and UI
			#sound effect for buying upgrade, and maybe a little popup text that says "Upgrade bought!" or smth
		else:
			#sound effect for not enough shells, and maybe a little popup text that says "Not enough shells!" or smth
			print("Not enough shells to buy this upgrade")
	else:
		if Player.urchins >= Player.getUpgradeCost(upgradeType, upgradeIndex):
			Player.emit_signal("buy_upgrade", upgradeType, upgradeIndex) #send event to main scene to update player stats and UI
			#sound effect for buying upgrade, and maybe a little popup text that says "Upgrade bought!" or smth
		else:
			#sound effect for not enough shells, and maybe a little popup text that says "Not enough shells!" or smth
			print("Not enough urchins to buy this upgrade")

func _on_update_cost():
	var upgrade: Dictionary
	var currency: String
	if upgradeType == 0:
		upgrade = Player.shellUpgrades[upgradeIndex]
		currency = "Shells"
	else:
		upgrade = Player.urchinUpgrades[upgradeIndex]
		currency = "Urchins"
	text = str(upgrade.name,' (', Player.getUpgradeCost(upgradeType, upgradeIndex),  ' ', currency, '): \n', upgrade.description)
