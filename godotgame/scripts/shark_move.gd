extends AnimatedSprite2D

# Variables de configuración
@export var start_position: Vector2 = Vector2(-220, 80)  # Punto inicial
@export var end_position: Vector2 = Vector2(160, 80)  # Punto final
@export var speed: float = 30  # Velocidad de movimiento

# Variables internas
var moving_to_end: bool = true  # Indica si se mueve hacia el punto final

func _ready():
	# Coloca el sprite en la posición inicial
	position = start_position
	# Inicia la animación
	play("default")  # Reproduce la animación 'default'

func _process(delta):
	# Determinar dirección de movimiento
	var target_position = end_position if moving_to_end else start_position
	var direction = (target_position - position).normalized()
	
	# Mover el sprite
	position += direction * speed * delta

	# Voltear el sprite si cambia de dirección
	flip_h = direction.x < 0

	# Revisar si llegó al destino
	if position.distance_to(target_position) < 5:  # Tolerancia de 5px
		moving_to_end = not moving_to_end  # Cambia de dirección
