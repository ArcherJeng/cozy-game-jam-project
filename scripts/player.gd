extends Node

const shellUpgrades := [
	{
		"name": "More Shells",
		"description": "Adds more shells that can be collected. Each upgrade increases the amount of shells collected by 1.",
		"baseCost": 2,
		"costMultiplier": 2
	},
	{
		"name": "Faster Ocean Waves",
		"description": "Makes the waves faster and more frequent.",
		"baseCost": 10,
		"costMultiplier": 2
	},
	{
		"name": "Shell Duplication",
		"description": "Gives a chance for shells to duplicate when collected. Each upgrade increases the chance by 5%.",
		"baseCost": 10,
		"costMultiplier": 3
	}
]

const urchinUpgrades := [
	{
		"name": "More Urchins",
		"description": "Adds more urchins that can be collected. Each upgrade increases the amount of urchins collected by 1.",
		"baseCost": 5,
		"costMultiplier": 2
	},
	{
		"name": "Faster Ocean Waves",
		"description": "Makes the waves faster and more frequent.",
		"baseCost": 10,
		"costMultiplier": 2
	},
	{
		"name": "Urchin Duplication",
		"description": "Gives a chance for urchins to duplicate when collected. Each upgrade increases the chance by 5%.",
		"baseCost": 10,
		"costMultiplier": 3
	}
]


var currentShellUpgrades := [0, 0, 0] #tracks how many times each shell upgrade has been bought
var currentUrchinUpgrades := [0, 0, 0] #tracks how many times each urchin upgrade has been bought

var shells := 0
var urchins := 0

signal shell_pressed 
signal urchin_pressed
signal buy_upgrade(upgradeType, upgradeIndex) #sent when an upgrade is bought, with the type and index of the upgrade, used to update player stats in main scene
signal on_upg_bought
signal urchins_unlocked #sent when player has 10 urchins and negative shells, used to show the urchin shop button in main scene
signal generate_shells #sent when ocean wave reaches the top, used to generate shells in shell generator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shells = 0
	urchins = 0
	load_game()

	buy_upgrade.connect(_on_buy_upgrade)
	shell_pressed.connect(_on_shell_pressed)
	urchin_pressed.connect(_on_urchin_pressed)
	pass # Replace with function body.

func _process(_delta: float) -> void:
	save_game()

func _on_shell_pressed():
	shells += 1
	#check for duplication upgrade
	var dupChance = currentShellUpgrades[2] * 5 #5% chance per level of the third shell upgrade
	if randi() % 100 < dupChance:
		shells += 1 #duplicate the shell


func _on_urchin_pressed():
	urchins += 1
	#check for duplication upgrade
	var dupChance = currentUrchinUpgrades[2] * 5 #5% chance per level of the third urchin upgrade
	if randi() % 100 < dupChance:
		urchins += 1 #duplicate the urchin


func _on_buy_upgrade(upgradeType, upgradeIndex):
	buyUpgrade(upgradeType, upgradeIndex)

#upgradeType: 0 for shell, 1 for urchin. upgradeIndex is the index of the upgrade in the respective array
func buyUpgrade(upgradeType: int, upgradeIndex: int):
	if upgradeType == 0:
		var upgrade = shellUpgrades[upgradeIndex]
		var cost = upgrade["baseCost"] * pow(upgrade["costMultiplier"], currentShellUpgrades[upgradeIndex])
		if shells >= cost:
			shells -= cost
			currentShellUpgrades[upgradeIndex] += 1
			emit_signal("on_upg_bought") #send event to main scene to update UI and apply effects
	elif upgradeType == 1:
		var upgrade = urchinUpgrades[upgradeIndex]
		var cost = upgrade["baseCost"] * pow(upgrade["costMultiplier"], currentUrchinUpgrades[upgradeIndex])
		if urchins >= cost:
			urchins -= cost
			currentUrchinUpgrades[upgradeIndex] += 1
			emit_signal("on_upg_bought") #send event to main scene to update UI and apply effects

#get upgrade cost based on type and index, used to check if player can afford upgrade and to display cost in UI
func getUpgradeCost(upgradeType: int, upgradeIndex: int) -> int:
	if upgradeType == 0:
		var upgrade = shellUpgrades[upgradeIndex]
		return upgrade["baseCost"] * pow(upgrade["costMultiplier"], currentShellUpgrades[upgradeIndex])
	elif upgradeType == 1:
		var upgrade = urchinUpgrades[upgradeIndex]
		return upgrade["baseCost"] * pow(upgrade["costMultiplier"], currentUrchinUpgrades[upgradeIndex])
	else :
		push_warning("Invalid upgrade type or index: " + str(upgradeType) + ", " + str(upgradeIndex))
		return -1 #invalid upgrade type

func checkIfUpgradeAffordable(upgradeType: int, upgradeIndex: int) -> bool:
	var cost := getUpgradeCost(upgradeType, upgradeIndex)
	if cost == -1:
		push_warning("Invalid upgrade type or index: " + str(upgradeType) + ", " + str(upgradeIndex))
		return false
	if upgradeType == 0:
		return shells >= cost
	elif upgradeType == 1:
		return urchins >= cost
	else:
		push_warning("Invalid upgrade type or index: " + str(upgradeType) + ", " + str(upgradeIndex))
		return false


#save game to cache
func save_game():
	var file := FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if file:
		var save_data := {
			"shells": shells,
			"urchins": urchins,
			"currentShellUpgrades": currentShellUpgrades,
			"currentUrchinUpgrades": currentUrchinUpgrades
		}
		file.store_string(JSON.stringify(save_data))
		file.close()
	else:
		push_error("Failed to save game: Could not open file for writing.")

#load game from cache
func load_game():
	var file_path := "user://savegame.json"
	if FileAccess.file_exists(file_path):
		var file := FileAccess.open(file_path, FileAccess.READ)
		if file:
			var json := JSON.new()
			var save_data := json.parse(file.get_as_text())
			if save_data == OK:
				var data = json.data
				shells = data.get("shells", 0)
				urchins = data.get("urchins", 0)
				currentShellUpgrades = data.get("currentShellUpgrades", [0, 0, 0])
				currentUrchinUpgrades = data.get("currentUrchinUpgrades", [0, 0, 0])
			else:
				push_warning("Failed to load game: Invalid save data format.")
				shells = 0
				urchins = 0
				currentShellUpgrades = [0, 0, 0]
				currentUrchinUpgrades = [0, 0, 0]
			file.close()
		else:
			push_warning("Failed to load game: Could not open file for reading.")
			shells = 0
			urchins = 0
			currentShellUpgrades = [0, 0, 0]
			currentUrchinUpgrades = [0, 0, 0]
	else:
		print("No save file found. Starting new game.")
		shells = 0
		urchins = 0
		currentShellUpgrades = [0, 0, 0]
		currentUrchinUpgrades = [0, 0, 0]

func reset_game():
	shells = 0
	urchins = 0
	currentShellUpgrades = [0, 0, 0]
	currentUrchinUpgrades = [0, 0, 0]
	save_game()

func check_urchin_shop_unlock():
	#called from main scene after every shell and urchin press, checks if player has 10 urchins and negative shells to unlock urchin shop
	if urchins >= 10 and shells < 0:
		emit_signal("urchins_unlocked") #send event to shop button to show the urchin shop button
