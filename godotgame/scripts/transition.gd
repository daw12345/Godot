extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.music_pos = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/Hall.tscn")	
