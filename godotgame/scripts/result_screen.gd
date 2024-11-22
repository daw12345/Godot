extends Node2D

# Variables de los nodos
@onready var money_label = $money  # Etiqueta para mostrar el saldo restante
@onready var profit_label = $profit  # Etiqueta para mostrar el total ganado/perdido
@onready var dog_labels = [
	$DogPlace1,
	$DogPlace2,
	$DogPlace3,
	$DogPlace4,
	$DogPlace5,
	$DogPlace6,
	$DogPlace7,
	$DogPlace8
]  # Lista de etiquetas para las posiciones de los perros
@onready var winner_sprite = $Winner  # AnimatedSprite2D donde se mostrará el perro ganador

func _ready():
	# Verificar si hay resultados de carrera disponibles
	if GameData.race_results.is_empty():
		print("Error: No hay resultados de carrera disponibles.")
		for label in dog_labels:
			if label != null:
				label.text = "No hay datos."
		return

	# Variables para calcular ganancias/pérdidas
	var total_profit = 0

	# Mostrar las posiciones de los perros en las etiquetas
	for i in range(dog_labels.size()):
		var position_label = dog_labels[i]
		var dog_id = -1  # Inicializamos dog_id con un valor predeterminado

		if position_label != null:
			if i < GameData.race_results.size():
				# Acceder correctamente al ID del perro
				var dog = GameData.race_results[i]
				dog_id = dog["id"]  # Acceder al dog_id del diccionario

				# Texto para la posición: "-1st Dog(x) (id)"
				var position_suffix = get_position_suffix(i + 1)
				position_label.text = "- " + str(i + 1) + position_suffix + " Dog(" + str(dog_id) + ")"
			else:
				# Si no hay más datos, limpiar las etiquetas restantes
				position_label.text = "Sin datos."

		# Calcular ganancias/pérdidas si el perro tiene una apuesta asociada
		if dog_id != -1 and dog_id in GameData.bet_amounts:
			var bet_amount = GameData.bet_amounts[dog_id]
			if dog_id == GameData.race_winner:
				var winnings = bet_amount * GameData.payout_rates[dog_id - 1]
				total_profit += winnings
			else:
				total_profit -= bet_amount

	# Mostrar el saldo restante
	if money_label != null:
		money_label.text = str(GameData.balance)

	# Mostrar el total de ganancias o pérdidas
	if profit_label != null:
		profit_label.text = total_profit_text(total_profit)

	# Mostrar el sprite del ganador
	show_winner_sprite()

func show_winner_sprite():
	# Obtener el ID del ganador
	var winner_id = GameData.race_winner

	# Verificar si el ID del ganador está dentro del rango válido (1 a 8)
	if winner_id >= 1 and winner_id <= 8:
		# Verificar si el nodo AnimatedSprite2D está presente y es del tipo correcto
		if winner_sprite != null and winner_sprite is AnimatedSprite2D:
			# Cambiar la animación en función del ID del perro ganador
			winner_sprite.animation = str(winner_id)  # La animación se nombra como "1", "2", "3", etc.
			winner_sprite.play()  # Reproducir la animación
		else:
			print("Error: El nodo 'Winner' no es un AnimatedSprite2D o no se encontró.")
	else:
		print("Error: ID de perro ganador inválido.")

func get_position_suffix(position):
	# Devuelve el sufijo para una posición ordinal en inglés
	match position:
		1:
			return "st"
		2:
			return "nd"
		3:
			return "rd"
		_:
			return "th"

func total_profit_text(profit):
	# Devuelve un texto formateado dependiendo de si es ganancia o pérdida
	if profit >= 0:
		return "$" + str(profit)  # Ganancia positiva
	else:
		return "-$" + str(abs(profit))  # Pérdida negativa
		


# Lógica para manejar el botón "Continuar"


func _on_continue_pressed() -> void:
	if GameData.gameOver_On and GameData.balance <=0:
		get_tree().change_scene_to_file("res://scenes/gameOver.tscn")
		print("GameOver")

	print("Continuar presionado. Cambiando de escena...")
	get_tree().change_scene_to_file("res://scenes/Hall.tscn")
