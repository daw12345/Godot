extends AnimatedSprite2D

@export var dog_parameters : Resource

# Variables del perro
var dog_params : DogParameters = null
var current_speed : float = 0.0
var top_speed : float = 0.0
var target_speed : float = 0.0
var race_started : bool = false
var is_bursting : bool = false
var race_ended : bool = false
var is_first_place : bool = false 
var slow_factor : float = 0.5
var burst_used : bool = false
var burst_time_left : float = 0.0
var stop_time_left : float = 0.0
var burst_triggered : bool = false
var stop_triggered : bool = false
var dog_id : int = -1  # ID único para cada perro

# Función para asignar parámetros al perro
func set_dog_parameters(params : DogParameters):
	dog_params = params
	top_speed = dog_params.max_speed * slow_factor
	current_speed = dog_params.base_speed * slow_factor
	target_speed = current_speed

# Función que se ejecuta cuando la escena está lista
func _ready():
	if dog_parameters == null:
		print("Error: No se ha asignado DogParameters al perro.")
		return
	
	set_dog_parameters(dog_parameters)
	play("idle")
	print(self.name, " ha sido inicializado con parámetros.")

# Función para iniciar la carrera
func start_race():
	race_started = true
	print(self.name, " está comenzando la carrera!")

# Función para detener la carrera
func stop_race():
	race_started = false
	current_speed = current_speed / 2  # Reduce la velocidad final

	if is_first_place:
		print(self.name, " ha terminado la carrera en primer lugar y se pone en idle.")
		play("idle")  # Se queda en idle si es el primero
	else:
		print(self.name, " ha terminado la carrera y se pone en lazy.")
		play("lazy")  # Se queda en lazy si no es el primero
		current_speed *= 0.5
	
	print(self.name, " ha detenido la carrera.")

# Función para actualizar la velocidad de la animación según la velocidad del perro
func update_animation_speed():
	var speed_scale_target = (current_speed / dog_params.max_speed) * 2.5 + 0.5
	speed_scale = lerp(speed_scale, speed_scale_target, 0.1)

# Lógica principal de la carrera y fluctuaciones
func _process(delta):
	if not race_started:
		return

	# Verificar si el burst está activo
	if burst_time_left > 0:
		burst_time_left -= delta
		current_speed = lerp(current_speed, top_speed, 0.05)
		if burst_time_left <= 0:
			is_bursting = false
			burst_used = true  # Marcar que el burst ya fue utilizado
			print(self.name, ": El burst ha terminado.")
	elif stop_time_left > 0:
		# Si la parada está activa
		stop_time_left -= delta
		current_speed = 0  # Mantener la velocidad en 0 durante la parada
		if stop_time_left <= 0:
			top_speed = lerp(dog_params.min_speed, dog_params.max_speed, randf()) * slow_factor
			print(self.name, ": La parada ha terminado, volviendo a velocidad normal")
	else:
		# Si no hay burst ni parada, posibilidad de activar burst o parada
		if not burst_used and not stop_triggered and randf() < dog_params.fluctuation_burst_chance * 0.5:
			if randf() < 0.5:  # Probabilidad equiprobable entre burst o parada
				# Activar el burst usando el impulso personalizado
				top_speed = dog_params.max_speed * dog_params.burst_impulse * slow_factor
				burst_time_left = dog_params.fluctuation_burst_duration  # Duración definida por fluctuation_burst_duration
				is_bursting = true
				burst_triggered = true  # El burst ha sido activado
				print(self.name, ": ¡Súper Acelerón Gradual con Impulso Personalizado! Nueva top speed: ", top_speed)
			else:
				# Activar la parada con duración igual a fluctuation_burst_duration
				top_speed = 0
				stop_time_left = min(dog_params.fluctuation_burst_duration, 10.0)  # Limitar el tiempo de parada a 10 segundos  # Duración igual a fluctuation_burst_duration
				stop_triggered = true  # La parada ha sido activada
				print(self.name, ": ¡Parada repentina! Duración de parada: ", stop_time_left)

		# Fluctuar la velocidad máxima solo si no hay burst ni parada
		if not is_bursting and stop_time_left <= 0 and randf() < 0.05:
			top_speed = lerp(dog_params.min_speed, dog_params.max_speed, randf()) * slow_factor

	# Suavizar la aceleración hacia el top_speed si no estamos en burst ni parada
	if not is_bursting and stop_time_left <= 0:
		target_speed = lerp(target_speed, top_speed, 0.1)
		current_speed = target_speed

	# Deceleración cuando el perro ha llegado a la meta
	if race_ended:
		if current_speed > 0:
			current_speed = lerp(current_speed, 0.0, 0.05)
			if current_speed <= 0.05:
				current_speed = 0.0

		# Fijar la animación final dependiendo de si está en primer lugar o no
		if is_first_place:
			if animation != "idle":
				play("idle")  # El perro se queda en "idle" si es el primero
		else:
			if animation != "lazy":
				play("lazy")  # El perro se queda en "lazy" si no es el primero

	# Actualizar la animación basada en la velocidad SOLO SI NO SE HA TERMINADO LA CARRERA
	if not race_ended:
		if current_speed > dog_params.base_speed and animation != "run":
			play("run")
		elif current_speed <= dog_params.base_speed and animation != "lazy" and not is_first_place:
			play("lazy")
		elif current_speed <= dog_params.base_speed and animation != "idle" and is_first_place:
			play("idle")

	# Mover al perro basado en la velocidad
	position.x += current_speed * delta

	# Actualizar la velocidad de la animación
	update_animation_speed()

# Función para marcar al perro como el primero en llegar
func mark_as_first_place():
	if not is_first_place:
		is_first_place = true
		race_ended = true
		print(self.name, " ha llegado en primer lugar!")
		play("idle")  # Pone la animación en 'idle' cuando es el primer lugar
		# Llamar a stop_race para que se detenga el perro
		stop_race()
