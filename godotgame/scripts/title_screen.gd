extends Node2D

@onready var title : AnimatedSprite2D = $AnimatedSprite2D
@onready var b1 : Button = $Start
@onready var b2 : Button = $Instructions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.visible = false
	b1.visible = false
	b2.visible = false
	await get_tree().create_timer(3.0).timeout  
	title.visible = true
	title.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(4.5).timeout
	b1.visible = true
	b2.visible = true


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Transition.tscn")	


func _on_instructions_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Instructions.tscn")	
