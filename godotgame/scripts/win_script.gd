extends Node2D
@onready var title : Sprite2D = $Win
@onready var lady : AnimatedSprite2D = $lady
@onready var prota : AnimatedSprite2D = $prota
@onready var emoji : AnimatedSprite2D = $"<3"
@onready var end : Button = $end

@onready var music : AudioStreamPlayer2D = $"16-GoodEnding"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.play()
	prota.visible = true
	lady.visible = true
	title.visible = false
	end.visible = false
	emoji.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	await get_tree().create_timer(2.0).timeout
	emoji.visible = true
	emoji.play("default")
	await get_tree().create_timer(2.0).timeout
	title.visible=true
	end.visible = true


func _on_end_pressed() -> void:
	GameData.music_pos = 0.0
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")
