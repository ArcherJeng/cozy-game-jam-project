extends TextureRect
var minLoops := 2
var maxLoops := 6

var loopCount := 0
var currentLoop := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _process(_delta: float) -> void:
	if randf() < 0.005: # 0.1% chance every frame to do the shiny animation
		if !$AnimationPlayer.is_playing(): #only play if not already playing, to avoid interrupting the animation
			loopCount = randi_range(minLoops, maxLoops)
			currentLoop = 0
			play_anim()

func play_anim() -> void:
	$AnimationPlayer.play("urchin_anim")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "urchin_anim":
		currentLoop += 1
		if currentLoop < loopCount:
			play_anim()
		else:
			$AnimationPlayer.play("RESET")
			$AnimationPlayer.advance(0)
