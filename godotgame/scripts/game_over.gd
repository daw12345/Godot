extends Node2D

@onready var panel: Sprite2D = $Diags
@onready var boss: AnimatedSprite2D = $boss
@onready var prota: AnimatedSprite2D = $prota
@onready var title: Sprite2D = $Gameover
@onready var end: Button = $back

var speed = 1  # Velocidad de movimiento 
var target_y_position = 10  # Posición final en Y para el título
var is_title_moving = false  # Para controlar si el título está en movimiento

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel.visible = false
	title.visible = false
	end.visible = false
	prota.visible = true
	boss.visible = true
	prota.flip_h = true
	prota.play("normal")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Hacer que el boss camine con una pausa antes de comenzar
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo antes de comenzar

	# Mover al boss de forma gradual
	boss.play("walk")
	var start_position = Vector2(boss.position.x, boss.position.y)  # Posición inicial del boss
	var target_position = Vector2(400, boss.position.y)  # Posición final
	var distance = target_position.x - start_position.x  # Distancia a recorrer
	var move_step = speed * delta  # Distancia recorrida por frame (ajustada por el delta)

	# Movimiento gradual hacia la posición final
	while abs(distance) > 0.1:  # Verifica si el boss ha llegado a la posición
		boss.position.x = lerp(boss.position.x, target_position.x, move_step / abs(distance))
		await get_tree().create_timer(delta).timeout  # Espera el siguiente frame para continuar
	
	boss.play("talk")

	# El prota reacciona
	prota.play("oh")

	# Acción de conversación, el boss habla
	await get_tree().create_timer(2.0).timeout  # Espera para la acción "oh"
	
	panel.visible = true
	
	# Panel visible por un tiempo antes de desaparecer
	await get_tree().create_timer(2.0).timeout  # Panel visible por 2 segundos
	panel.visible = false
	
	# El boss pide el dinero
	boss.play("pay me")
	await get_tree().create_timer(0.5).timeout  # Boss "pay me" durante 2 segundos
	
	# El prota responde "bye bye"
	prota.play("bye bye")
	await get_tree().create_timer(2.5).timeout  # Deja 1.5 segundos para la respuesta
	
	# El boss deja de hablar y detiene la animación
	boss.play("stop")
	await get_tree().create_timer(1.0).timeout  # Pausa para la animación de "stop"
	
	# Hacer que el título sea visible y se mueva suavemente
	title.visible = true
	await get_tree().create_timer(0.5).timeout  # Espera para que la visibilidad sea efectiva
	
	
	
	# Mover el título gradualmente a su posición final en Y
	is_title_moving = true  # Indicar que el título está en movimiento
	while abs(title.position.y - float(target_y_position)) > 1:  # Mientras no llegue a la posición final
		title.position.y = lerp(title.position.y, float(target_y_position), speed * delta)
		await get_tree().create_timer(delta).timeout  # Espera al siguiente frame
	
	# Una vez que el título llegue a la posición deseada, lo dejamos quieto
	title.position.y = float(target_y_position)  # Asegura que se quede exactamente en la posición final
	
	# Esperar para la animación del título
	await get_tree().create_timer(1.5).timeout  # Tiempo suficiente para que el título se mueva

	# Finalmente, se muestra la pantalla de fin
	end.visible = true
	await get_tree().create_timer(1.0).timeout  # Espera para que el panel de fin se vea bien


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
