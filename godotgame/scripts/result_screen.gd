extends Node2D

@onready var result_label = $result_label  # Asegúrate de que 'result_label' es un Label o RichTextLabel

func _ready():
	var result_text = "Resultado de la carrera: "

	# Verificar si el jugador ganó la apuesta
	if GameData.bet_dog_id != -1:
		if GameData.bet_dog_id == GameData.race_winner:
			result_text += "¡Ganaste! "
		else:
			result_text += "Perdiste. "
	else:
		result_text += "No realizaste ninguna apuesta."

	# Verificar si result_label es válido antes de asignar el texto
	if result_label != null:
		result_label.text = result_text  # Para Label
		# Si usas RichTextLabel, usa bbcode_text en lugar de text:
		# result_label.bbcode_text = result_text
	else:
		print("Error: 'result_label' no encontrado en la escena.")
