extends Panel  # Aplica el script al nodo Panel

# Nodos internos del cuadro de diálogo
@onready var dialog_text: Label = $DialogText
@onready var option1_button: Button = $Drink
@onready var option2_button: Button = $Cancel
@onready var face: Sprite2D = $face
var can_interact: bool = false

func _ready():
	# Al inicio, el cuadro de diálogo está oculto
	visible = false
	dialog_text.text = "Wanna drink,
	sugar?"
	# Conectar las señales directamente en el editor o de manera explícita en el código
	# Conectamos las señales de los botones para las acciones correspondientes
	option1_button.connect("pressed", Callable(self, "_on_option1_pressed"))
	option2_button.connect("pressed", Callable(self, "close"))
	face.modulate = Color(1.0, 1.0, 1.0, 0.4)
func start_dialogue():
	# Muestra el cuadro de diálogo y habilita los botones
	visible = true
	can_interact = true
	

	# Establecemos las opciones de los botones
	option1_button.text = "Apostar 100 monedas"
	option2_button.text = "Cancelar"

	# Habilitamos los botones y los hacemos visibles
	option1_button.visible = true
	option2_button.visible = true

func _on_option1_pressed():
	# Acción al presionar la opción 1 (apostar)
	if GameData.balance >= 20:
		GameData.balance -= 20
		print("Consumicion -20, el saldo ahora es: " + str(GameData.balance))
		dialog_text.text ="It's $20, darling
		 See you!" 
		# Mostrar el mensaje de despedida
		option1_button.visible = false  # Deshabilitar el botón de opción 1
		option2_button.visible = false  # Deshabilitar el botón de opción 2
		face.modulate = Color(0.0, 0.0, 0.0, 0.0)
		
	else:
		dialog_text.text = "Not enough cash.."
		
		option1_button.visible = false  # Deshabilitar el botón de opción 1
		option2_button.visible = false  # Deshabilitar el botón de opción 2
		face.modulate = Color(1.0, 1.0, 1.0, 0.0)
	await get_tree().create_timer(2.0).timeout  
	
	
		# Restaurar el texto del diálogo al estado inicial
	dialog_text.text = "Wanna drink,
	sugar?"  # Este es el mensaje original de inicio
	
	# Restaurar visibilidad y habilitar botones
	option1_button.text = "Drink"  # El texto original del primer botón
	option2_button.text = "Cancel"  # El texto original del segundo botón
	option1_button.disabled = false  # Habilitar el botón de opción 1
	option2_button.disabled = false  # Habilitar el botón de opción 2
	option1_button.visible = true  # Asegurarse de que el botón de opción 1 esté visible
	option2_button.visible = true  # Asegurarse de que el botón de opción 2 esté visible
	face.modulate = Color(1.0, 1.0, 1.0, 0.4)
	# Ocultar el cuadro de diálogo
	visible = false  # Ocultar el panel del diálogo
	
	# Restablecer la interacción
	can_interact = false  # Deshabilitar la interacción con el diálogo

# Función para resetear y cerrar el diálogo
func close():
	print("Cerrando diálogo...")

	# Mostrar el mensaje de despedida antes de cerrar el cuadro de diálogo
	dialog_text.text = "See you, honey!"  # Mostrar el mensaje de despedida
	option1_button.visible = false  
	option2_button.visible = false
	face.modulate = Color(0.0, 0.0, 0.0, 0.0)
	# Esperar un poco antes de cerrar
	await get_tree().create_timer(1.0).timeout  # Esperar 1 segundo
	
	# Restaurar el texto del diálogo al estado inicial
	dialog_text.text = "Wanna drink,
	sugar?"  # Este es el mensaje original de inicio
	
	# Restaurar visibilidad y habilitar botones
	option1_button.text = "Drink"  # El texto original del primer botón
	option2_button.text = "Cancel"  # El texto original del segundo botón
	option1_button.disabled = false  # Habilitar el botón de opción 1
	option2_button.disabled = false  # Habilitar el botón de opción 2
	option1_button.visible = true  # Asegurarse de que el botón de opción 1 esté visible
	option2_button.visible = true  # Asegurarse de que el botón de opción 2 esté visible
	face.modulate = Color(1.0, 1.0, 1.0, 0.4)
	# Ocultar el cuadro de diálogo
	visible = false  # Ocultar el panel del diálogo
	
	# Restablecer la interacción
	can_interact = false  # Deshabilitar la interacción con el diálogo
