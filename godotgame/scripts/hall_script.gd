extends Node2D
@onready var money : Label = $interface/guita

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money.visible = true
	money.text = str(GameData.balance) + "$"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money.text = str(GameData.balance) + "$"

	if GameData.drink_overdose == 20:
		get_tree().change_scene_to_file("res://scenes/gameOver2.tscn")
		
	if GameData.her_love == 1000:
		get_tree().change_scene_to_file("res://scenes/win.tscn")
