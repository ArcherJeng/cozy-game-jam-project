extends VBoxContainer

@export var upgradeType := 0 #0 for shell, 1 for urchin
var upgrades := [] #array of upgrades to display, set in main scene when opening upgrade menu
var buttonScene := preload("res://scenes/upgradebutton.tscn")


@onready var shellShopButton := self.get_parent().get_node("ShellShopButton")
@onready var urchinShopButton := self.get_parent().get_node("UrchinShopButton")

@onready var currency := "shells" if upgradeType == 0 else "urchins"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	if upgradeType == 0:
		upgrades = Player.shellUpgrades
	else:
		upgrades = Player.urchinUpgrades
	
	#create buttons for each upgrade
	for upgrade in upgrades:
		var button := buttonScene.instantiate()
		button.upgradeType = upgradeType
		button.upgradeIndex = upgrades.find(upgrade)

		if upgradeType == 0:
			button.theme = load("res://Assets/Themes/maintheme.tres")
		else:
			button.theme = load("res://Assets/Themes/urchintheme.tres")
		# show shells if upgrade type = 0, urchins if upgrade type = 1
		
		button.text = str(upgrade.name,' (', Player.getUpgradeCost(upgradeType, upgrades.find(upgrade)),  ' ', currency, '): \n', upgrade.description)
		add_child(button)
	
	var exitButton := Button.new()
	exitButton.text = "Exit"
	exitButton.pressed.connect(_on_exit_button_pressed)
	add_child(exitButton)

	Player.start.connect(_on_start)

func _on_exit_button_pressed():
	#close the upgrade menu, return to main scene
	self.hide()

	if upgradeType == 0:
		shellShopButton.show()
	else:
		urchinShopButton.show()

	
		
func _process(_delta: float) -> void:
	if !Player.urchins_unlocked_bool && upgradeType == 1:
		self.hide()

func _on_start():
	_on_exit_button_pressed()