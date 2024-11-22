extends Node2D

@onready var talk : Label = $Label/blabla # Referencia al Label donde se muestran los diálogos
@onready var panel : Sprite2D = $Label
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
# Lista de diálogos
var dialogues : Array = [
	"this punk's the real deal, 
	don't you think?
	don't try to play funny",
	"you think the waitress is cute? 
	don't even think about it, 
	ashe's mine",
	"mr rocco's gonna show you 
	what real power looks like",
	"get lost, idiot"
]


var entered = false


func _ready() -> void:
	panel.visible = false
	anim.play("idle")
	
var current_dialogue_index : int = 0  # Índice para seguir la posición actual del diálogo



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_button") and entered:
		panel.visible = true  # Mostrar el cuadro de diálogo
		talk.text = dialogues[current_dialogue_index]  # Mostrar la primera frase
		
		
# Función que se ejecuta cuando se presiona el botón "Next"
func _on_next_pressed() -> void:
	# Si aún hay más diálogos
	if current_dialogue_index < (dialogues.size() -1):
		talk.text = dialogues[current_dialogue_index + 1]  # Mostrar el diálogo actual
		current_dialogue_index += 1  # Avanzar al siguiente diálogo
	else:
		# Si ya no hay más diálogos, cerrar el cuadro de diálogo
		panel.visible = false  # Ocultar el Label
		current_dialogue_index = 0
		print("No more dialogues!")
	
# Función que se ejecuta cuando un cuerpo entra al área de colisión
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "prota":
		entered = true
			

# Función que se ejecuta cuando el cuerpo sale del área de colisión
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "prota":  # Si el personaje sale del área
		entered = false
		panel.visible = false  # Ocultar el cuadro de diálogo
		current_dialogue_index = 0
