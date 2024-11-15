extends Node2D

var dogs = []  # Lista de perros en la carrera
var race_distance = 1000  # Distancia de la carrera (en píxeles)
var race_timer : Timer  # Temporizador para iniciar la carrera
var dogs_finished = 0  # Número de perros que han llegado a la meta
var race_results = []  # Lista para almacenar los perros que han llegado a la meta
var race_ended = false  # Bandera para asegurarse de que la carrera termine solo una vez

func _ready():
	# Obtener todos los perros en la escena
	dogs = get_tree().get_nodes_in_group("dogs")  # Añadir los perros al grupo "dogs"
	
	# Crear y configurar el temporizador
	race_timer = Timer.new()
	add_child(race_timer)
	race_timer.wait_time = 4.0  # Esperar 4 segundos antes de iniciar la carrera
	race_timer.one_shot = true  # No repetir

	# Conectar la señal de timeout del temporizador a la función _on_race_start
	race_timer.connect("timeout", Callable(self, "_on_race_start"))
	
	# Mostrar mensaje de preparación
	print("Preparándose para la carrera...")

	# Iniciar la cuenta regresiva
	race_timer.start()  # Comienza el temporizador para el inicio de la carrera

# Función llamada cuando se activa el temporizador para iniciar la carrera
func _on_race_start():
	print("¡La carrera ha comenzado!")
	start_race()

# Función para iniciar la carrera
func start_race():
	# Reiniciar el contador de perros terminados y los resultados
	dogs_finished = 0
	race_results.clear()  # Limpiar los resultados previos
	# Iniciar la carrera para todos los perros
	for dog in dogs:
		dog.start_race()  # Llamar a la función que inicia la carrera de cada perro

# Función para comprobar si algún perro ha cruzado la meta
func _process(delta):
	# Comprobar si algún perro ha cruzado la meta
	for dog in dogs:
		# Si el perro ha llegado a la meta y no ha sido contado aún
		if dog.position.x >= race_distance and not dog.race_ended:
			dog.race_ended = true  # Marcar que el perro ha terminado la carrera
			dogs_finished += 1  # Incrementar el contador de perros que han llegado
			race_results.append(dog)  # Agregar el perro a los resultados
			dog.stop_race()  # Detener al perro en cuanto cruce la meta

	# Si todos los perros han terminado y la carrera aún no ha sido detenida
	if dogs_finished == dogs.size() and not race_ended:
		stop_race()

# Función para detener la carrera cuando haya un ganador
func stop_race():
	# Detener la carrera para todos los perros
	for dog in dogs:
		if dog.race_ended:
			dog.stop_race()  # Llamar a la función que detiene la carrera de cada perro

	# Imprimir los resultados finales **solo después de que todos los perros hayan llegado**
	if not race_ended:
		print("La carrera ha terminado. Resultados finales:")

		# Ordenar los perros por su posición (mayor posición primero)
		race_results.sort_custom(_compare_by_position)  # Ordenamos la lista con el método de comparación

		# Marcar al primero como 'is_first_place'
		for i in range(race_results.size()):
			var dog = race_results[i]
			print(str(i + 1) + ". " + dog.name)  # Imprimir el nombre del perro y su puesto
			if i == 0:
				dog.mark_as_first_place()  # Marcar al perro como el ganador
				GameData.race_winner = i  # Guardar el índice del ganador en lugar de `dog_id`

		# Evaluar si el jugador ganó la apuesta
		var win_message = "Perdiste la apuesta. "
		if GameData.bet_dog_id == GameData.race_winner:
			GameData.balance += GameData.bet_amounts[GameData.bet_dog_id] * 2  # Doble del monto apostado si gana la apuesta
			win_message = "¡Ganaste la apuesta! "
		# Muestra el mensaje de ganancia o pérdida
		print(win_message + "Tu saldo actual es de $", GameData.balance)

		# Cambia a la pantalla de resultados
		get_tree().change_scene_to_file("res://scenes/resultScreen.tscn")

		# Establecer la bandera para evitar que se repita
		race_ended = true

# Función de comparación para ordenar los perros por su posición (de mayor a menor)
func _compare_by_position(a, b):
	# Comparar por la posición X para ordenarlos por la llegada
	return a.position.x > b.position.x  # El perro con mayor valor de X llega primero
