extends Node2D

enum RaceState { PREPARING, IN_PROGRESS, FINISHED }
var race_state = RaceState.PREPARING  # Comienza en estado de preparación

# Lista de perros en la carrera
var dogs = []
var race_distance = 1000  # Distancia de la carrera (en píxeles)

# Referencia para el temporizador
var race_timer : Timer

func _ready():
	# Obtener todos los perros en la escena
	dogs = get_tree().get_nodes_in_group("dogs")  # Hay que asegurarse de haber añadido los perros al grupo "dogs"
	
	# Crear un temporizador para controlar el inicio de la carrera
	race_timer = Timer.new()
	add_child(race_timer)
	race_timer.wait_time = 4.0  # Esperar 4 segundos antes de iniciar la carrera
	race_timer.one_shot = true  # No repetir
	
	# Conectar la señal de timeout del temporizador a la función _on_race_start
	race_timer.connect("timeout", Callable(self, "_on_race_start"))
	
	# Mostrar mensaje de preparación
	print("Preparándose para la carrera...")

	# Iniciar la cuenta regresiva
	prepare_race()

func _process(delta):
	# Verificar si la carrera está en progreso
	if race_state == RaceState.IN_PROGRESS:
		# Verificar si algún perro ha cruzado la meta
		check_race_progress()

# Llamada cuando se activa el temporizador para iniciar la carrera
func _on_race_start():
	print("¡La carrera ha comenzado!")
	start_race()

# Función para iniciar la carrera
func start_race():
	# Cambiar el estado de la carrera
	race_state = RaceState.IN_PROGRESS
	
	# Iniciar la carrera para todos los perros
	for dog in dogs:
		dog.start_race()  # Llamar a la función que inicia la carrera de cada perro

# Comprobar el progreso de la carrera y ver si algún perro ha cruzado la meta
func check_race_progress():
	for dog in dogs:
		if dog.position.x >= race_distance:
			print(dog.name, " ha ganado la carrera!")
			race_state = RaceState.FINISHED
			stop_race()
			break  # Terminar la carrera cuando un perro gane

# Detener la carrera cuando haya un ganador
func stop_race():
	# Detener la carrera para todos los perros
	for dog in dogs:
		dog.stop_race()  # Llamar a la función que detiene la carrera de cada perro
	print("La carrera ha terminado.")

# Función para iniciar la cuenta regresiva antes de la carrera
func prepare_race():
	race_state = RaceState.PREPARING
	print("Esperando para iniciar la carrera...")
	race_timer.start()  # Comienza el temporizador para el inicio de la carrera
