extends Control

@onready var music_slider = $VBoxContainer/MusicSlider
@onready var sfx_slider = $VBoxContainer/SFXSlider

var music_bus_index: int
var sfx_bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")

	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))

	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)

func _on_music_slider_changed(value: float):
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_index, value <= 0.05)

func _on_sfx_slider_changed(value: float):
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_index, value <= 0.05)