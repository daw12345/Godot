extends Node2D
@onready var bg : AnimatedSprite2D = $AnimatedSprite2D
@onready var lb : Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg.visible = false
	lb.visible = false
	bg.play("default")
	await get_tree().create_timer(2.0).timeout
	bg.visible = true
	lb.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	
	
	
	await get_tree().create_timer(6.0).timeout
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")	
	 
