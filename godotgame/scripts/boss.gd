extends Node2D

var is_in_dialog_zone: bool = false
var is_dialog_active: bool = false
@onready var panel: Panel = $bossDialog
@onready var boss: AnimatedSprite2D = $bossAnimation
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel.visible=false
	boss.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_in_dialog_zone and Input.is_action_just_pressed("action_button") and not is_dialog_active:
		get_tree().paused = true  # Pausa el juego mientras el diálogo está activo
		panel.visible=true
		boss.play("talk1")

func _on_area_2d_body_entered(body: Node2D) -> void:
			# Detecta si el jugador entra en la zona del personaje
	if body.name == "prota":  # Ajusta según el nombre del nodo del jaugador
		is_in_dialog_zone = true
		print("entro al boss")
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "prota":  # Ajusta según el nombre del nodo del jugador
		is_in_dialog_zone = false
		print("salio del boss")
