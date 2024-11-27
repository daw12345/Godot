extends Node2D

@onready var b : Button = $controls
@onready var b2 : Button = $Button
@onready var music : AudioStreamPlayer2D = $Skogen14

# Referencias a los sprites para los diferentes estados del volumen
@onready var mute_sprite : Sprite2D = $muted
@onready var low_volume_sprite : Sprite2D = $Sound1
@onready var medium_volume_sprite : Sprite2D = $Sound2
@onready var high_volume_sprite : Sprite2D = $Sound3
@onready var max_volume_sprite : Sprite2D = $bomb
@onready var text1 = $Label3

var sound : float = 10.0  # Nivel de sonido (0.0 a 1.0)

func _ready() -> void:
	music.play(GameData.music_pos)
	update_volume_sprite()  # Actualiza los sprites al inicializar la escena
	high_volume_sprite.visible = true
func _process(delta: float) -> void:
	pass

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Instructions.tscn")    
	GameData.music_pos = music.get_playback_position()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")    
	GameData.music_pos = music.get_playback_position()

func _on_h_slider_value_changed(value: float) -> void:
	sound = value / 100.0  # Convierte el valor del slider a un rango de 0.0 a 1.0
	AudioServer.set_bus_volume_db(0, linear_to_db(sound))
	update_volume_sprite()  # Actualiza los sprites en función del volumen

func update_volume_sprite() -> void:
	# Oculta todos los sprites al inicio
	mute_sprite.visible = false
	low_volume_sprite.visible = false
	medium_volume_sprite.visible = false
	high_volume_sprite.visible = false
	max_volume_sprite.visible = false
	text1.visible = false
	# Determina qué sprite hacer visible según el nivel de sonido
	if sound == 0.0:
		mute_sprite.visible = true
	elif sound > 0.0 and sound <= 0.25:
		low_volume_sprite.visible = true
	elif sound > 0.25 and sound <= 0.5:
		medium_volume_sprite.visible = true
	elif sound > 0.5 and sound < 1.0:
		high_volume_sprite.visible = true
	elif sound == 1.0:
		max_volume_sprite.visible = true
		text1.visible = true
