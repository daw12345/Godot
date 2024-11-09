extends AnimatedSprite2D

# Parámetros por perro
class DogParameters:
	var base_speed : float
	var max_speed : float
	var min_speed : float
	var acceleration_rate : float
	var fluctuation_rate : float
	var change_delay : float
	var fluctuation_burst_chance : float
	var fluctuation_burst_duration : float

# Variables del perro
var dog_params : DogParameters
var current_speed : float = 0.0  # Velocidad actual
var top_speed : float = 0.0  # Velocidad máxima fluctuante
var change_timer : float = 0.0  # Temporizador para cambios de velocidad
var fluctuation_timer : float = 0.0  # Temporizador para fluctuaciones normales
var burst_timer : float = 0.0  # Temporizador para super acelerones
var is_bursting : bool = false  # Indica si está en super acelerón o parada
var idle_timer : float = 3.0  # Tiempo en "idle" antes de empezar a moverse
var race_started : bool = false  # Indica si la carrera ha comenzado

# Función para asignar parámetros al perro
func set_dog_parameters(params : DogParameters):
	dog_params = params
	top_speed = dog_params.max_speed  # Establecer velocidad máxima

func _ready():
	# Inicializar el estado del perro
	play("idle")  # Animación "idle" inicial

	# Establecer parámetros por defecto para el perro
	var params = DogParameters.new()
	params.base_speed = 50.0
	params.max_speed = 1700.0
	params.min_speed = 300.0
	params.acceleration_rate = 500.0
	params.fluctuation_rate = 0.1
	params.change_delay = 2.0
	params.fluctuation_burst_chance = 0.1
	params.fluctuation_burst_duration = 8.0
	
	set_dog_parameters(params)  # Asignar parámetros al perro

# Función para iniciar la carrera
func start_race():
	race_started = true  # La carrera comienza
	idle_timer = 0  # Empezar a moverse inmediatamente
	print(self.name, " está comenzando la carrera!")

# **Función que detiene la carrera**
func stop_race():
	race_started = false  # La carrera se detiene
	current_speed = 0  # Detener la velocidad
	play("idle")  # Cambiar a animación "idle"
	print(self.name, " ha detenido la carrera.")

# Función para actualizar la velocidad de la animación según la velocidad del perro
func update_animation_speed():
	var speed_scale_target = (current_speed / dog_params.max_speed) * 2.5 + 0.5
	speed_scale = lerp(speed_scale, speed_scale_target, 0.1)  # Suavizado en la animación

func _process(delta):
	# Si la carrera no ha comenzado, no hacer nada
	if not race_started:
		return

	# 1. Fluctuar la velocidad máxima (top speed)
	change_timer += delta
	if change_timer >= dog_params.change_delay:
		# Cambiar aleatoriamente la top speed
		if not is_bursting:
			top_speed = lerp(dog_params.min_speed, dog_params.max_speed, randf())
		change_timer = 0.0  # Resetear temporizador para la siguiente fluctuación

	# 2. Comprobar si hay fluctuación brusca (super acelerón o parada)
	if randf() < dog_params.fluctuation_burst_chance and not is_bursting:
		if randf() < 0.5:
			# Super acelerón: Aumentamos la velocidad drásticamente
			top_speed = lerp(dog_params.max_speed / 2, dog_params.max_speed * 2, randf())
			print("¡Súper Acelerón! Nueva top speed: ", top_speed)
		else:
			# Parada: Reducimos la velocidad a casi cero
			top_speed = 0
			print("¡Parada repentina! Top speed es 0")
		burst_timer = dog_params.fluctuation_burst_duration
		is_bursting = true

	# 3. Mantener el super acelerón o la parada
	if is_bursting:
		burst_timer -= delta
		if burst_timer <= 0:
			is_bursting = false
			top_speed = lerp(dog_params.min_speed, dog_params.max_speed, randf())  # Reiniciar top speed

	# 4. Acelerar o desacelerar hacia la top speed
	if current_speed < top_speed:
		current_speed += dog_params.acceleration_rate * delta
		if current_speed > top_speed:
			current_speed = top_speed
	elif current_speed > top_speed:
		current_speed -= dog_params.acceleration_rate * delta
		if current_speed < top_speed:
			current_speed = top_speed

	# 5. Actualizar la animación basada en la velocidad
	if current_speed > dog_params.base_speed and animation != "run":
		play("run")  # Cambiar a "run" si el perro se mueve
	elif current_speed <= dog_params.base_speed and animation != "lazy":
		play("lazy")  # Cambiar a "lazy" si está detenido

	# 6. Mover al perro basado en la velocidad
	position.x += current_speed * delta

	# 7. Actualizar la velocidad de la animación
	update_animation_speed()
