extends Node2D

@onready var title : AnimatedSprite2D = $AnimatedSprite2D
@onready var b1 : Button = $Start
@onready var b2 : Button = $Instructions
@onready  var music : AudioStreamPlayer2D = $Skogen14

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.visible = false
	b1.visible = false
	b2.visible = false
	
	music.play(GameData.music_pos)

	
	
	await get_tree().create_timer(2.5).timeout  
	title.visible = true
	title.play("default")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(3.7).timeout
	b1.visible = true
	b2.visible = true


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Transition.tscn")	


func _on_instructions_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Instructions.tscn")	
	GameData.music_pos = music.get_playback_position()
	print(GameData.music_pos)
