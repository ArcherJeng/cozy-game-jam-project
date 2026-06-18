extends Control

var defaultTime := 3
var time := defaultTime #time it takes for wave to go up and down, reduced by upgrades
var initPos := Vector2(0, -632)
var finalPos := Vector2(0, 0)
var defaultDelayTime := 17
var delayTime := defaultDelayTime #in seconds, time between waves, reduced by upgrades

@onready var timer := self.get_node("Timer")
@onready var shellsNode := %shells
@onready var urchinsNode := %urchins

var waveOngoing := false

func _ready() -> void:
	position = initPos

	$oceanTexture/AnimationPlayer.play("ocean_anim")

	Player.on_upg_bought.connect(_on_upg_bought)
	timer.wait_time = delayTime
	timer.start()
	print(timer)
	execute_wave() #start the first wave immediately when the scene starts

func execute_wave():
	if waveOngoing:
		return #don't execute a new wave if one is already ongoing
	waveOngoing = true
	position.x = initPos.x
	print("Executing wave, time: ", time, " delayTime: ", delayTime)
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position:y", finalPos.y, time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished

	_regen_items()

	var tweenback := get_tree().create_tween()
	tweenback.tween_property(self, "position:y", initPos.y, time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(.5)

	await tweenback.finished

	waveOngoing = false

func _regen_items():
	for child in shellsNode.get_children():
		child.queue_free()
	for child in urchinsNode.get_children():
		child.queue_free()
	
	Player.emit_signal("generate_shells") #tell shells scene to generate shells at the start of the wave
	Player.emit_signal("generate_urchins") #tell urchin scene to generate urchins at the start of the wave
	

func _on_timer_timeout():
	print("timer timeout for ocean wave")
	execute_wave()

func _on_upg_bought():
	timer.stop() #stop the timer to reset it with the new delay time
	delayTime = max(1, defaultDelayTime - ((Player.currentShellUpgrades[1] + Player.currentUrchinUpgrades[1]) * 1)) #reduce time by 1 seconds for each level of the first shell upgrade, with a minimum of 1 seconds
	time = max(0.5, defaultTime - ((Player.currentShellUpgrades[1] + Player.currentUrchinUpgrades[1]) * 0.2)) #reduce time by 0.25 seconds for each level of the second shell upgrade, with a minimum of 0.5 seconds
	timer.wait_time = delayTime
	timer.start() #restart the timer with the new delay time
