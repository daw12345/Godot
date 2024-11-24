extends Node2D

# Variables de configuración
@onready var prota: AnimatedSprite2D = $prota  
@onready var boss: AnimatedSprite2D = $boss  
@onready var title: Sprite2D = $Gameover
@onready var panel: Sprite2D = $Diags
@onready var end: Button = $back

# Variables de movimiento
@export var start_position: Vector2 = Vector2(694,-26)  # Punto inicial del boss (fuera de pantalla)
@export var end_position: Vector2 = Vector2(394, -26)  # Punto final del boss
@export var speed: float = 110  # Velocidad de movimiento del boss

# Variable para controlar si el boss ha llegado a su destino
var arrived: bool = false

# Función _ready() se ejecuta al inicio de la escena
func _ready() -> void:
	title.visible = false
	panel.visible = false
	end.visible = false
	
	# Coloca al protagonista en la animación "normal"
	prota.play("normal")  # Animación "idle"
	prota.flip_h = true  # El protagonista mira hacia la derecha (no volteado)
	
	# Coloca al boss en la posición inicial
	boss.position = start_position  # Aseguramos que el boss empiece en el lugar correcto

func _process(delta):
	
	await get_tree().create_timer(2.0).timeout  # Espera 2 segundos
	# Si el boss ya ha llegado a su destino, no hacer nada más
	if arrived:
		return  # Sale del proceso sin hacer nada más

	# Movimiento del boss
	var direction = (end_position - boss.position).normalized()  # Calculamos la dirección hacia el destino
	boss.position += direction * speed * delta  # Movemos al boss a lo largo de la dirección
	boss.play("walk")
	prota.play("oh")
	# Si el boss ha llegado a la posición final
	if boss.position.distance_to(end_position) < 1:  # Tolerancia de 1px
		boss.position = end_position  # Aseguramos que llegue exactamente al final
		arrived = true  # Marcamos que el boss ha llegado al destino
		boss.play("talk")
		panel.visible=true
		await get_tree().create_timer(2.0).timeout  # Espera 2 segundos
		panel.visible = false
		boss.play("pay me")
		await get_tree().create_timer(0.5).timeout  
		prota.play("bye bye")
		await get_tree().create_timer(2.0).timeout  
		boss.play("normal")
		await get_tree().create_timer(2.0).timeout  
		title.visible = true
		end.visible = true

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")
