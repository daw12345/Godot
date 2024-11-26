extends Node

@onready var fondo1 : AnimatedSprite2D = $"Race2(1)"
@onready var fondo2 : AnimatedSprite2D = $"Race3(1)"
@onready var go : Sprite2D = $Gogoogo
@onready var text = $RichTextLabel



var music_player : AudioStreamPlayer = null
var sound : AudioStreamPlayer2D = null


var dogs = []  # Lista de perros en la carrera
var race_distance = 9000  # Distancia de la carrera (en píxeles)
var race_timer : Timer  # Temporizador para iniciar la carrera
var dogs_finished = 0  # Número de perros que han llegado a la meta
var race_results = []  # Lista para almacenar los perros que han llegado a la meta
var race_ended = false  # Bandera para asegurarse de que la carrera termine solo una vez

func _ready():
		# Crear una lista con las 5 URLs de los archivos de música
	var music_urls = [
		"res://assets/Megaman-2_-Dr-Wily-Theme-8-bit-theme.mp3",
		"res://assets/242050_Guile_s_Theme_8_Bit.mp3",
		"res://assets/02 Bloody Tears.mp3"
	]

	# Elegir una URL aleatoriamente de la lista
	var random_music_url = music_urls[randi() % music_urls.size()]

	# Crear un AudioStreamPlayer2D
	var music_player = AudioStreamPlayer.new()

	# Cargar la música aleatoria seleccionada usando load
	var stream = load(random_music_url)

	# Verificar que el recurso se haya cargado correctamente
	if stream:
		music_player.stream = stream
		add_child(music_player)

		# Ajustar el volumen
		music_player.set_volume_db(0.0)

		# Reproducir la música
		music_player.play()
		
		
		
	else:
		print("Error al cargar la música desde: ", random_music_url)

	sound = AudioStreamPlayer2D.new()
	sound.stream = preload("res://assets/SE-27.mp3")
	add_child(sound)  
	sound.set_volume_db(15.0)
	
	
	
	
	# Obtener todos los perros en la escena (perros deben estar en el grupo "dogs")
	dogs = get_tree().get_nodes_in_group("dogs")
	text.visible = true
	go.visible = false
	
	
	fondo1.play("default")
	fondo2.play("default")
	# Asignar IDs únicos a cada perro basado en el nombre del AnimatedSprite
	for dog in dogs:
		var dog_name = dog.name  # El nombre de cada perro (Dog1, Dog2, etc.)
		var dog_id = int(dog_name.substr(3, 1))  # Extraer el ID del nombre
		dog.dog_id = dog_id  # Asignar el ID al perro
	
	# Crear y configurar el temporizador
	race_timer = Timer.new()
	add_child(race_timer)
	race_timer.wait_time = 8.0  # Esperar 4 segundos antes de iniciar la carrera
	race_timer.one_shot = true  # No repetir
	race_timer.connect("timeout", Callable(self, "_on_race_start"))
	
	print("Preparándose para la carrera...")
	race_timer.start()  # Inicia el temporizador

func _on_race_start():
	sound.play()
	print("¡La carrera ha comenzado!")
	start_race()
	go.visible=true
	text.visible = false
	await get_tree().create_timer(1.5).timeout
	go.visible=false
	
func start_race():
	# Reiniciar contador de perros y resultados
	dogs_finished = 0
	race_results.clear()
	for dog in dogs:
		dog.start_race()  # Inicia la carrera para cada perro

func _process(delta):
	
	# Verificar si algún perro ha cruzado la meta
	for dog in dogs:
		if dog.position.x >= race_distance and not dog.race_ended:
			dog.race_ended = true
			dogs_finished += 1
			race_results.append(dog)
			dog.stop_race()

			# Si es el primer perro en cruzar la meta, marcarlo como el primero (ganador)
			if dogs_finished == 1:
				dog.mark_as_first_place()

	# Si todos los perros han terminado y la carrera aún no ha sido detenida
	if dogs_finished == dogs.size() and not race_ended:
		stop_race()

func stop_race():
	# Detener la carrera de todos los perros
	for dog in dogs:
		if dog.race_ended:
			dog.stop_race()

	# Si la carrera no ha sido terminada aún
	if not race_ended:
		print("La carrera ha terminado. Resultados finales:")

		# Guardar resultados de la carrera en GameData
		GameData.race_results.clear()
		for index in range(race_results.size()):
			var dog = race_results[index]
			var position = index + 1  # Posición basada en el índice
			GameData.race_results.append({
				"id": dog.dog_id,
				"name": dog.name,
				"position": position
			})
			print("Posición " + str(position) + ": Perro " + str(dog.dog_id))

		# Determinar el perro ganador
		var winning_dog = race_results[0]  # El primer perro en la lista es el ganador
		GameData.race_winner = winning_dog.dog_id
		print("Ganador: Perro", winning_dog.dog_id)

		# Feedback de las apuestas
		var results_feedback = ""
		for dog_id in GameData.bet_amounts.keys():
			var bet_amount = GameData.bet_amounts[dog_id]
			if dog_id == GameData.race_winner:
				# Ajuste en el índice de apuestas (dog_id - 1) para acceder correctamente a las apuestas
				var winnings = bet_amount * GameData.payout_rates[dog_id - 1]  # dog_id - 1 para el índice correcto
				GameData.balance += winnings
				results_feedback += "¡Ganaste la apuesta al Perro " + str(dog_id) + "! Ganaste $" + str(winnings) + ".\n"
			else:
				results_feedback += "Perdiste la apuesta al Perro " + str(dog_id) + ". Apostaste $" + str(bet_amount) + ".\n"

		print(results_feedback)
		print("Tu saldo actual es de $", GameData.balance)
		
		race_ended = true
		
		# Cambiar a la pantalla de resultados
		get_tree().change_scene_to_file("res://scenes/resultScreen.tscn")

func _compare_by_position(a, b):
	# Ordenamos según la posición en la carrera (la posición más alta en X es la que más avanzó)
	return a.position.x > b.position.x
