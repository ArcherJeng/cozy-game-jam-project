extends Control

var time := 3 #time it takes for wave to go up and down, reduced by upgrades
var initPos := Vector2(0, -632)
var finalPos := Vector2(0, 0)
var delayTime := 20 #in seconds, time between waves, reduced by upgrades

@onready var timer := self.get_node("Timer")

var waveOngoing := false

func _ready() -> void:
	position = initPos

	$oceanTexture/AnimationPlayer.play("ocean_anim")

	Player.on_upg_bought.connect(_on_upg_bought)
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = delayTime
	timer.start()
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

	Player.emit_signal("generate_shells") #tell shells scene to generate shells at the start of the wave

	var tweenback := get_tree().create_tween()
	tweenback.tween_property(self, "position:y", initPos.y, time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(.5)


func _on_timer_timeout():
	execute_wave()

func _on_upg_bought():
	timer.stop() #stop the timer to reset it with the new delay time
	delayTime = max(1, time - (Player.currentShellUpgrades[0] * 1)) #reduce time by 1 seconds for each level of the first shell upgrade, with a minimum of 1 seconds
	time = max(0.5, time - (Player.currentShellUpgrades[1] * 0.25)) #reduce time by 0.25 seconds for each level of the second shell upgrade, with a minimum of 0.5 seconds
	timer.wait_time = delayTime
	timer.start() #restart the timer with the new delay time
