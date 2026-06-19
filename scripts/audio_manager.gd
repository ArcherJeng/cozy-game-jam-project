extends Node

@onready var music_player := $MusicPlayer
@onready var sfx_player := $SFXPlayer
@onready var ocean_player := $OceanPlayer
@onready var waves_player := $WavesPlayer

@onready var bg_music := preload("res://Assets/Audio/oceanbeach.wav")
@onready var ocean_sounds = preload("res://Assets/Audio/oceansounds.mp3") #https://pixabay.com/sound-effects/rmultimediaeu-ocean-waves-sound-02-321572/

@onready var sfx_dict: Dictionary = {
	"collectShell": preload("res://Assets/Audio/collectshell.mp3"), #https://pixabay.com/sound-effects/film-special-effects-retro-coin-4-236671/
	"collectUrchin": preload("res://Assets/Audio/collecturchin.mp3"), #https://pixabay.com/sound-effects/film-special-effects-8-bit-gravel-footsteps-1-408582/
	"oceanWave": preload("res://Assets/Audio/oceanwave.mp3"), #https://pixabay.com/sound-effects/nature-ocean-waves-376898/
	"duplicated": preload("res://Assets/Audio/duplicated.mp3"), #https://pixabay.com/sound-effects/technology-points-474079/
	"upgradeBought": preload("res://Assets/Audio/upgradebought.mp3"), #https://pixabay.com/sound-effects/film-special-effects-8-bit-powerup-6768/
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_music(bg_music)
	play_ocean()

#in case I feel like making more bg music
func play_music(stream: AudioStream):
	if music_player.stream == stream and music_player.playing:
		return
	music_player.stream = stream
	music_player.play()

func play_sfx(stream: String):
	if stream == "oceanWave":
		waves_player.stream = sfx_dict[stream]
		waves_player.play()
	else:
		sfx_player.stream = sfx_dict[stream]
		sfx_player.play()

func play_ocean():
	ocean_player.stream = ocean_sounds
	ocean_player.play()
