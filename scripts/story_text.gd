extends Control

var text := [
	"Intro\n
	You're Sam, Sally's brother, and she needs you to help her collect some seashells for her seashell business! Collect seashells along the shore, and get 300 seashells to kickstart her business! \n
	You can also use your seashells to buy upgrades from the conveniently placed seashell upgrade shop that manipulates the waters to aid you in your seashell collecting journey!\n
	However, whatever you do, DO NOT COLLECT SEA URCHINS!! They will take away your seashells, even ones you don't have yet! Something bad may happen if you dive too deep into those waters...",

	"Sea Urchins\n
	You dove too deep into collecting sea urchins, that Sally left you. She's going to be collecting her own seashells now, while you continue doing... whatever with your sea urchins.\n
	However, you noticed a sea urchin upgrade shop that you didn't see before, for whatever reason, so at least you can collect more now!\n
	Perhaps you should try Sally's seashell business but with sea urchins...",

	"Win Condition?\n
	You collected enough seashells to kickstart Sally's business!! However, she realized that she doesn't want you to be a part of it, and kicked you out!\n
	You try looking by the shore for purpose in life, but they wash you away, leaving only ASHES... If only you could try again, realizing your fate in collecting seashells...",

	"Win Condition.\n
	You collected enough sea urchins to start your sea urchin business!! Sally will try to compete with you, but you are no match, and even sabotage her by using the urchins to take away her stock!\n
	You have all the power in the world, so what will you do with it? If you really wanted to, you could even replay your fate, or take a different path..."
]

@onready var textBox := $Textbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	$ResetButton.hide()
	Player.urchins_unlocked.connect(_on_urchins_unlocked)
	Player.start.connect(_on_intro)
	Player.on_upg_bought.connect(_on_upg_bought)
	$ExitButton.pressed.connect(_on_exit_pressed)
	


func _on_intro():
	$ResetButton.hide()
	if Player.shells == 0:
		textBox.text = text[0]
		self.show()
	else:
		self.hide()

func _on_urchins_unlocked():
	textBox.text = text[1]
	self.show()

func _on_upg_bought():
	if Player.currentShellUpgrades[Player.currentShellUpgrades.size()-1] > 0:
		textBox.text = text[2]
		self.show()
		$ResetButton.show()
	elif Player.currentUrchinUpgrades[Player.currentUrchinUpgrades.size()-1] > 0:
		textBox.text = text[3]
		self.show()
		$ResetButton.show()

func _on_exit_pressed():
	self.hide()