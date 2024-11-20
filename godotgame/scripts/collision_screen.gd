extends Node2D

# Referencias a los nodos
@onready var popup_sprite: AnimatedSprite2D = $PopupSprite  # Nodo del popup


# Bandera para verificar si el jugador puede interactuar
var can_interact: bool = false

func _ready() -> void:
	# Asegurarse de que el PopupSprite esté oculto al principio
	popup_sprite.visible = false

# Detectar si el personaje entra en el área
func _on_screen_body_entered(body: Node2D) -> void:
	if body.name == "prota":  # Asegurarse de que es el personaje
		popup_sprite.modulate = Color(1, 1, 1, 0.9)  # Parcialmente transparente
		popup_sprite.play("default")
		can_interact = true
		popup_sprite.visible = true  # Mostrar el popup
		
		print("El personaje ha entrado en el área de interacción")

# Detectar si el personaje sale del área
func _on_screen_body_exited(body: Node2D) -> void:
	if body.name == "prota":  # Asegurarse de que es el personaje
		popup_sprite.stop()
		can_interact = false
		popup_sprite.visible = false  # Ocultar el popup
		print("El personaje ha salido del área de interacción")

func _process(delta: float) -> void:
	# Verificar si el jugador presiona el botón de acción y puede interactuar
	if can_interact and Input.is_action_just_pressed("action_button"):
		print("Interacción realizada. Cambiando de escena...")
		get_tree().change_scene_to_file("res://scenes/betMenu.tscn")
