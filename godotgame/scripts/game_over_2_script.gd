extends Node2D

# Variables de configuración
@onready var prota: AnimatedSprite2D = $prota  
@onready var title: Sprite2D = $Gameover
@onready var panel: Sprite2D = $Diags
@onready var end: Button = $back

# Función _ready() se ejecuta al inicio de la escena
func _ready() -> void:
	title.visible = false
	panel.visible = false
	end.visible = false

	prota.visible = true
	prota.play("idle") 

	# Iniciar la secuencia de animaciones
	_start_sequence()

# Función asincrónica para manejar la secuencia de animaciones
func _start_sequence() -> void:
	# Secuencia de animaciones con temporizadores
	await get_tree().create_timer(2.0).timeout  # Espera 2 segundos
	prota.play("oh")
	
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo
	panel.visible = true

	await get_tree().create_timer(2.0).timeout  # Espera 2 segundos
	panel.visible = false
	prota.play("bye")
	
	await get_tree().create_timer(2.0).timeout  # Espera 2 segundos
	title.visible = true
	end.visible = true

# Función para manejar el evento cuando se presiona el botón "back"
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
