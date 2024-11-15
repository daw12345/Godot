extends Node

# Función para confirmar la apuesta
func confirm_bet():
	# Simula una apuesta fija en el perro con ID 1 y apuesta de 100
	GameData.bet_dog_id = 1
	GameData.bet_amount = 100

	# Actualiza el saldo al hacer la apuesta
	GameData.balance -= GameData.bet_amount
	print("Apuesta realizada en el perro", GameData.bet_dog_id, "con una cantidad de $", GameData.bet_amount)
	print("Saldo restante: $", GameData.balance)

	# Cambia a la escena de carrera
	get_tree().change_scene_to_file("res://scenes/race.tscn")

# Llama a confirm_bet() desde un botón en el menú de apuestas para confirmar la apuesta
