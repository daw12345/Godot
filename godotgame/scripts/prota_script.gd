extends CharacterBody2D

# Variables de configuración
@export var speed: float = 100  # Velocidad de movimiento

# Referencia al AnimatedSprite2D
@onready var animated_sprite: AnimatedSprite2D = $protaSprites

func _ready():
	# Establecer la animación "idle" al inicio
	animated_sprite.play("idle")

func _process(delta):
	# Reiniciar el movimiento
	var direction = Vector2.ZERO

	# Detectar entradas de teclado
	if Input.is_action_pressed("ui_up"):       # W
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):     # S
		direction.y += 1
	if Input.is_action_pressed("ui_left"):     # A
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):    # D
		direction.x += 1

	# Normalizar dirección para evitar movimiento más rápido en diagonal
	direction = direction.normalized()

	# Establecer velocidad de movimiento
	velocity = direction * speed

	# Animar según el movimiento
	if direction == Vector2.ZERO:
		# Si no se mueve, reproducir animación "idle"
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
	else:
		# Si se mueve, reproducir animación "walk"
		if animated_sprite.animation != "walk":
			animated_sprite.play("walk")
		# Voltear horizontalmente según la dirección
		if direction.x != 0:
			animated_sprite.flip_h = direction.x >= 0  # Volteo invertido: derecha (>= 0) invierte el sprite

	# Aplicar movimiento
	move_and_slide()

	# Detectar el botón de acción
	if Input.is_action_just_pressed("action_button"):
		handle_action_button()

# Función que se ejecuta cuando se presiona el botón de acción
func handle_action_button():
	print("¡Acción ejecutada!")
	# Aquí puedes añadir la lógica para desencadenar eventos


func _on_screen_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
