extends Node

# Muestra los resultados cuando se carga la escena
func _ready():
	var result_text = "Resultado de la carrera:\n"
	result_text += "Ganaste la apuesta!" if GameData.won_bet else "Perdiste la apuesta."
	result_text += "\nSaldo actual: $" + str(GameData.balance)
	
	# Verificar si ResultLabel existe antes de intentar asignar el texto
	if $ResultLabel != null:
		$ResultLabel.text = result_text
	else:
		print("Error: ResultLabel no encontrado en la escena.")

# Función para regresar al menú de apuestas
func return_to_bet_menu():
	get_tree().change_scene_to_file("res://scenes/betMenu.tscn")
