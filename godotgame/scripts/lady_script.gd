extends AnimatedSprite2D

# Variables de configuración
@export var start_position: Vector2 = Vector2(0, 120)  # Punto inicial
@export var end_position: Vector2 = Vector2(100, 120)  # Punto final
@export var speed: float = 20  # Velocidad de movimiento
@export var idle_duration: float = 10.0  # Duración de espera en segundos

# Variables internas
var moving_to_end: bool = true  # Indica si se mueve hacia el punto final
var is_idle: bool = true  # Indica si está en estado de espera

# Temporizador manual para manejar los estados
var idle_timer: float = 0.0

func _ready():
	# Coloca el sprite en la posición inicial
	position = start_position



	# Inicia la animación idle
	play("idle")

func _process(delta):
	if is_idle:
		# Reducir el temporizador de inactividad
		idle_timer -= delta
		if idle_timer <= 0.0:
			play("walk")
			# Salir del estado de inactividad y comenzar a moverse
			is_idle = false
			# Cambiar la dirección de movimiento si se alcanzó el destino previo
			moving_to_end = not moving_to_end
		return

	# Determinar dirección de movimiento
	var target_position = end_position if moving_to_end else start_position
	var direction = (target_position - position).normalized()
	
	# Mover el sprite
	position += direction * speed * delta

	# Voltear el sprite si cambia de dirección
	flip_h = direction.x < 0

	# Revisar si llegó al destino
	if position.distance_to(target_position) < 5:  # Tolerancia de 5px
		# Cambia a estado de espera y reinicia el temporizador manual
		is_idle = true
		idle_timer = idle_duration
		if animation != "idle":  
			play("idle")
