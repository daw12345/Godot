extends Node2D

@export var max_bet_amount : int = 99999  # Máxima cantidad que se puede apostar
var bets : Dictionary = {}  # Diccionario de apuestas {perro_id: cantidad_apostada}
var total_bet_amount : int = 0  # Total apostado por el jugador

# Referencias a nodos del menú
@onready var balance_label = $money
@onready var confirm_button = $Confirm

# Referencias a los betSquares (LineEdit) para cada perro
@onready var dog_bet_squares = [
	$dog1/betSquare1,  # betSquare1 es el LineEdit
	$dog2/betSquare2,
	$dog3/betSquare3,
	$dog4/betSquare4,
	$dog5/betSquare5,
	$dog6/betSquare6,
	$dog7/betSquare7,
	$dog8/betSquare8
]

# Se ejecuta cuando el nodo está listo
func _ready():
	_update_balance_label()

	# Inicializar apuestas para cada perro
	for i in range(dog_bet_squares.size()):
		bets[i] = 0  # Inicialmente no hay apuestas
		
		# Verificar que el nodo dog_bet_squares[i] no sea null
		if dog_bet_squares[i] != null:
			dog_bet_squares[i].connect("text_changed", Callable(self, "_on_bet_input_changed").bind(i))
		else:
			print("Advertencia: dog_bet_squares[" + str(i) + "] es null.")
	
	# Conectar el botón de confirmación
	confirm_button.connect("pressed", Callable(self, "_on_confirm_button_pressed"))

# Actualizar la etiqueta del saldo
func _update_balance_label():
	balance_label.text = str(GameData.balance)

# Evento: Cambiar texto en un betSquare (LineEdit)
func _on_bet_input_changed(new_text, dog_id):
	# Intentar convertir el texto a un número entero
	var bet_amount = new_text.to_int()

	# Verificar si la conversión fue exitosa (si no, to_int devuelve 0)
	if bet_amount == 0 and new_text != "0":  # Si no es 0 y el texto no es "0", es inválido
		print("Por favor, ingresa una cantidad válida.")
		return
	
	# Restringir al saldo disponible y al límite máximo
	if bet_amount > GameData.balance:
		bet_amount = GameData.balance
	elif bet_amount > max_bet_amount:
		bet_amount = max_bet_amount
	
	# Actualizar la apuesta en el diccionario
	bets[dog_id] = bet_amount  # Registrar la apuesta

	# Calcular el total apostado
	total_bet_amount = 0
	for bet in bets.values():
		total_bet_amount += bet
	print("Apuestas actuales: ", bets)

# Evento: Confirmar apuesta
func _on_confirm_button_pressed():  
	# Verificar que el total apostado no exceda el saldo
	if total_bet_amount > GameData.balance:
		print("No tienes suficiente saldo para todas las apuestas.")
		return  # Salir de la función si el saldo es insuficiente
	
	# Si no se apostó a ningún perro, se sigue adelante con la carrera
	if total_bet_amount == 0:
		print("No has apostado a ningún perro. La carrera continuará igual.")
	
	# Confirmar todas las apuestas y actualizar el saldo
	GameData.bet_amounts = bets.duplicate()  # Guardar copia de las apuestas realizadas
	GameData.balance -= total_bet_amount
	print("Apuestas confirmadas:", GameData.bet_amounts)
	print("Saldo restante: $", GameData.balance)

	# Cambiar a la escena de carrera
	print("Cambiando a la escena de carrera...")
	get_tree().change_scene_to_file("res://scenes/race.tscn")
