extends Node2D
@onready var money : Label = $interface/guita
@onready var go : AnimatedSprite2D = $go


var entered = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money.visible = true
	money.text = str(GameData.balance) + "$"
	go.visible = false
	go.play("default")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("action_button") and entered:
			print("go")
			get_tree().change_scene_to_file("res://scenes/boss_room.tscn")
			GameData.player_position = Vector2(1066,168)
	
	money.text = str(GameData.balance) + "$"

	if GameData.drink_overdose == 20:
		get_tree().change_scene_to_file("res://scenes/gameOver2.tscn")
		GameData.gameOver_On = false
		
	if GameData.her_love == 1000:
		get_tree().change_scene_to_file("res://scenes/win.tscn")
		GameData.gameOver_On = false


func _on_door_body_entered(body: Node2D) -> void:
	if body.name == "prota":  
		go.visible=true
		entered = true


func _on_door_body_exited(body: Node2D) -> void:
	if body.name == "prota":  
		go.visible=false
		entered = false
