extends AnimatedSprite2D

# Variables de configuración
@export var start_position: Vector2 = Vector2(-220, 80)  # Punto inicial
@export var end_position: Vector2 = Vector2(160, 80)  # Punto final
@export var speed: float = 70  # Velocidad de movimiento
@export var y_offset: float = 20  # Desfase en Y al llegar al extremo

# Variables internas
var moving_to_end: bool = true  # Indica si se mueve hacia el punto final
var applied_offset: bool = false  # Controla si el offset ya ha sido aplicado
var return_position: Vector2  # Nueva posición de vuelta (start_position + y_offset)

func _ready():
	# Coloca el sprite en la posición inicial
	position = start_position
	# Inicia la animación
	play("default")  # Reproduce la animación 'default'
	# Inicializa la posición de vuelta
	return_position = start_position + Vector2(0, y_offset)

func _process(delta):
	# Determinar el punto objetivo
	var target_position = end_position if moving_to_end else return_position
	var direction = (target_position - position).normalized()

	# Mover el sprite
	position += direction * speed * delta

	# Voltear el sprite si cambia de dirección
	flip_h = direction.x < 0

	# Revisar si llegó al destino
	if position.distance_to(target_position) < 5:  # Tolerancia de 5px
		if moving_to_end and not applied_offset:
			# Al llegar al extremo final, aplicar el desfase en Y
			position.y += y_offset
			applied_offset = true
		elif not moving_to_end and applied_offset:
			# Al llegar a la nueva posición de vuelta (start_position + y_offset), restaurar el valor original de Y
			position.y = start_position.y
			applied_offset = false
		
		# Cambiar dirección
		moving_to_end = not moving_to_end
