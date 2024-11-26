extends Panel

# Variables para manejar el estado del diálogo
var is_in_dialog_zone: bool = false
var is_dialog_active: bool = false
var dialog_index: int = 0  # Índice del diálogo actual
var dialog_texts: Array = []  # Lista de textos del diálogo

# Referencia al nodo de diálogo
@onready var dialog_box: Label = $sharlita
@onready var next: Button = $next

var music_player : AudioStreamPlayer2D = null



func _ready() -> void:
	
	music_player = AudioStreamPlayer2D.new()
	music_player.stream = preload("res://assets/12 - Attack the Barbarian.mp3")
	add_child(music_player)  
	music_player.volume_db = 1
	
	
	
	# Establecemos los textos del diálogo
	dialog_texts = ["hey kid, you’re lucky i’m feeling 
	generous today. 
you owe me 20 grand, 
don’t play me", 
 "don’t make me regret this, 
alright? 
the last guy who tried that... 
well, he’s not around anymore", 
 "if you play me, 
you’ll end up chum for my sharks",
 "what are you gonna do with 
all that cash? well, 
i guess it’s none of my business", 
 "ha ha ha ha, cheer up kid, 
smile, 
life’s too short"]

	# Aseguramos que el botón 'Next' esté habilitado
	next.disabled = false
	next.connect("pressed", Callable(self, "_on_next_pressed"))
	
	
func _start_dialog() -> void:
	
	# Activa el diálogo y pausa el juego
	is_dialog_active = true
	visible = true  # Muestra el cuadro de diálogo
	dialog_index = 0  # Reinicia el índice del diálogo
	dialog_box.text = dialog_texts[dialog_index]  # Muestra el primer diálogo

func _end_dialog() -> void:
	# Finaliza el diálogo y reanuda el juego
	is_dialog_active = false

	visible = false  # Oculta el cuadro de diálogo

func _on_next_pressed() -> void:
	# Avanza al siguiente diálogo
	dialog_index += 1

	# Si hay más diálogos, se muestra el siguiente
	if dialog_index < dialog_texts.size():
		dialog_box.text = dialog_texts[dialog_index]
		print("Mostrando diálogo: ", dialog_texts[dialog_index])
	else:
		# Si se llegó al último diálogo, redirige a otra escena
		print("Se acabó el diálogo. Redirigiendo a otra escena...")
		_end_dialog()  # Cierra el diálogo
		get_tree().paused = false
		GameData.music_pos = music_player.get_playback_position()
		get_tree().change_scene_to_file("res://scenes/Contract.tscn") 
		
func _process(delta: float) -> void:
	
	if GameData.boss_music_cont:
		print("sonando..")
		music_player.play()
		GameData.boss_music_cont = false
