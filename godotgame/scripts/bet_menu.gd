extends Node2D

@export var max_bet_amount : int = 99999  # Máxima cantidad que se puede apostar
var bets : Dictionary = {}  # Diccionario de apuestas {perro_id: cantidad_apostada}
var total_bet_amount : int = 0  # Total apostado por el jugador
var bet_square_map : Dictionary = {}  # Diccionario para mapear betSquares a IDs de perros

# Referencias a nodos del menú
@onready var balance_label = $money
@onready var confirm_button = $Confirm
@onready var cancel: Button = $back


var music_player : AudioStreamPlayer2D = null
var sound : AudioStreamPlayer2D = null
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

func _ready():
	music_player = AudioStreamPlayer2D.new()
	music_player.stream = preload("res://assets/03 - Fighting in the Street.mp3")
	add_child(music_player)  
	music_player.set_volume_db(-8.0)
	music_player.play(GameData.music_pos)
	
	sound = AudioStreamPlayer2D.new()
	sound.stream = preload("res://assets/SE-37.mp3")
	add_child(sound)  
	sound.set_volume_db(-4.0)
	
	
	_update_balance_label()
	GameData.player_position = Vector2(42, -50)
	
	# Inicializar apuestas para cada perro, empezando desde el perro 1 hasta el perro 8
	for i in range(dog_bet_squares.size()):
		if dog_bet_squares[i] != null:
			var dog_id = i + 1  # Los perros tienen ID del 1 al 8, por lo que sumamos 1 al índice
			bets[dog_id] = 0  # Inicialmente no hay apuestas para ese perro

			# Mapear el LineEdit al ID del perro en GameData.DOG_IDS
			bet_square_map[dog_bet_squares[i]] = dog_id

			# Conectar el evento text_changed correctamente
			dog_bet_squares[i].connect("text_changed", Callable(self, "_on_bet_input_changed").bind(dog_bet_squares[i]))
		else:
			print("Advertencia: dog_bet_squares[" + str(i) + "] es null.")
	
	# Conectar el botón de confirmación
	confirm_button.connect("pressed", Callable(self, "_on_confirm_button_pressed"))
	
# Actualizar la etiqueta del saldo
func _update_balance_label():
	balance_label.text = str(GameData.balance)
	
# Evento: Cambiar texto en un betSquare (LineEdit)
func _on_bet_input_changed(new_text, bet_square):
	# Obtener el ID del perro asociado al betSquare desde bet_square_map
	var dog_id = bet_square_map.get(bet_square, -1)
	if dog_id == -1:
		print("Error: No se pudo encontrar el ID del perro asociado a este betSquare.")
		return

	# Intentar convertir el texto a un número entero
	var bet_amount = new_text.to_int()

	# Verificar si la conversión fue exitosa (si no, to_int devuelve 0)
	if bet_amount == 0 and new_text != "0":  # Si no es 0 y el texto no es "0", es inválido
		print("Por favor, ingresa una cantidad válida.")
		bet_square.text = ""  # Limpiar el campo para que el usuario lo intente de nuevo
		sound.play()
		return
	
	# Restringir al saldo disponible y al límite máximo
	if bet_amount > GameData.balance:
		bet_amount = GameData.balance
		bet_square.text = str(bet_amount)  # Actualizar el texto con la cantidad permitida
		print("Se ajustó la apuesta al saldo disponible.")
	elif bet_amount > max_bet_amount:
		bet_amount = max_bet_amount
		bet_square.text = str(bet_amount)  # Actualizar el texto con la cantidad máxima permitida
		print("Se ajustó la apuesta al máximo permitido.")
	
	# Actualizar la apuesta en el diccionario usando el ID correcto
	bets[dog_id] = bet_amount  # Registrar la apuesta para el perro con el ID correcto

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
		sound.play()
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
	get_tree().change_scene_to_file("res://scenes/Transition2.tscn")


func _on_back_pressed() -> void:
	GameData.music_pos = music_player.get_playback_position()
	
	get_tree().change_scene_to_file("res://scenes/Hall.tscn")
	
	
