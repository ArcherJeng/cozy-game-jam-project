extends TextureRect
var rng := RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	pass # Replace with function body.


# 2. every once in a while, do a shiny animation, then wait a random amount of time before doing it again
func _process(_delta: float) -> void:
	if rng.randf() < 0.005: # 0.1% chance every frame to do the shiny animation
		if !$AnimationPlayer.is_playing(): #only play if not already playing, to avoid interrupting the animation
			$AnimationPlayer.play("shell_shiny_anim")
			print("Playing shell shiny animation")
