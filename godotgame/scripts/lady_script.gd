extends Node2D

# Variables de configuración
@export var start_position: Vector2 = Vector2(-20, 0)  # Punto inicial
@export var end_position: Vector2 = Vector2(30, 0)  # Punto final
@export var speed: float = 20  # Velocidad de movimiento
@export var idle_duration: float = 10.0  # Duración de espera en segundos

# Variables internas
var moving_to_end: bool = true  # Indica si se mueve hacia el punto final
var is_idle: bool = true  # Indica si está en estado de espera

# Temporizador manual para manejar los estados
var idle_timer: float = 0.0

# Referencia al Sprite2D
@onready var sprite: AnimatedSprite2D = $lady
@onready var sprite2: AnimatedSprite2D = $emoji


func _ready():
	# Coloca el nodo en la posición inicial
	position = start_position
	
	sprite2.visible = false
	# Inicia la animación idle en el Sprite2D
	if sprite != null:
		sprite.play("idle")
		sprite.visible = true
		
		# Aseguramos que el sprite no esté volteado en "idle"
		sprite.flip_h = false
	else:
		print("nope")

func _process(delta):
	
	if is_idle:
		# Reducir el temporizador de inactividad
		idle_timer -= delta
		if idle_timer <= 0.0 and idle_timer >-1:
			# Salir del estado de inactividad y comenzar a moverse
			is_idle = false
			# Cambiar la dirección de movimiento si se alcanzó el destino previo
			moving_to_end = not moving_to_end
			if sprite != null:
				sprite.play("walk")
		return

	# Determinar dirección de movimiento
	var target_position = end_position if moving_to_end else start_position
	var direction = (target_position - position).normalized()
	
	# Mover el nodo
	position += direction * speed * delta

	# Solo voltear el sprite si está en "walk"
	if sprite.animation == "walk":
		# Voltear el sprite según la dirección de movimiento
		if direction.x > 0:
			# Voltear (mueve hacia la derecha)
			sprite.flip_h = true
		elif direction.x < 0:
			# Desvoltear (mueve hacia la izquierda)
			sprite.flip_h = false

	# Revisar si llegó al destino
	if position.distance_to(target_position) < 5:  # Tolerancia de 5px
		# Cambiar al estado de espera y reiniciar el temporizador manual
		is_idle = true
		idle_timer = idle_duration
		if sprite != null and sprite.animation != "idle":  
			sprite.play("idle")
			# Mantener la orientación original cuando está en "idle"
			sprite.flip_h = false


func _on_area_lady_body_entered(body: Node2D) -> void:
	print("El personaje ha entrado en el área2 de interacción")
	sprite2.visible = true
	if not is_idle:
		sprite.play("idle")
		sprite2.play("default")
		speed=0
		sprite.stop()
	idle_timer=-1

func _on_area_lady_body_exited(body: Node2D) -> void:
	print("El personaje ha salido del área2 de interacción")
	sprite2.visible = false
	idle_timer=5
	if not is_idle:
		
		sprite2.stop()
		speed=20
		sprite.play("walk")
		moving_to_end = false
	
