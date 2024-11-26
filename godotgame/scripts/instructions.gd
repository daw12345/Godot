extends Node2D
@onready var b : Button = $Button
@onready  var music : AudioStreamPlayer2D = $Skogen14
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.play(GameData.music_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")	
	GameData.music_pos = music.get_playback_position()
