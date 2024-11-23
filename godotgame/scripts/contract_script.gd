extends Control

var width = 400
var height = 400
var brush_size = 5  # Reducir el tamaño del trazo (cuadrado más pequeño)
var has_painted = false  # Variable para rastrear si algo ha sido pintado

@onready var layer = $signherebabe
@onready var done_button = $Done

func _ready() -> void:
	# Crear la imagen con las dimensiones especificadas
	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	img.fill(Color(1, 1, 1, 0))  # Blanco transparente (alfa = 0)
	
	# Crear la textura a partir de la imagen
	var texture = ImageTexture.create_from_image(img)
	layer.texture = texture
	
	# Esperar unos cuadros para que la imagen se cargue correctamente
	await 0.1
	
	# Ajustar el pivot del layer para que se alinee correctamente
	layer.pivot_offset.x = width / 2
	layer.pivot_offset.y = height / 2
	
	# Inicialmente el botón está invisible
	done_button.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Obtener posición local relativa al TextureRect
		var local_pos = layer.get_local_mouse_position()
		
		# Ajustar las coordenadas según el tamaño del TextureRect y el lienzo
		var scaled_pos = Vector2(
			local_pos.x * (width / float(layer.size.x)),
			local_pos.y * (height / float(layer.size.y))
		)

		# Pintar solo si el ratón está dentro de los límites del lienzo
		if scaled_pos.x >= 0 and scaled_pos.y >= 0 and scaled_pos.x < width and scaled_pos.y < height:
			# Marcar que se ha pintado algo
			has_painted = true
			draw_square(scaled_pos)

			# Si no estaba visible, hacer que el botón se vea
			if not done_button.visible:
				done_button.visible = true

# Función para dibujar un cuadrado continuo
func draw_square(position: Vector2):
	var img = layer.texture.get_image()

	var x = int(position.x)
	var y = int(position.y)
	
	# Verificar si el cursor está dentro de los límites de la imagen
	if x >= 0 and y >= 0 and x < img.get_width() and y < img.get_height():
		# Dibujar un cuadrado más fino y continuo en la posición indicada
		for dx in range(-brush_size, brush_size + 1):
			for dy in range(-brush_size, brush_size + 1):
				var draw_pos = Vector2(x + dx, y + dy)
				# Verificar si la posición está dentro de los límites de la imagen
				if draw_pos.x >= 0 and draw_pos.y >= 0 and draw_pos.x < width and draw_pos.y < height:
					img.set_pixelv(draw_pos, Color(0, 0, 0, 1))  # Color negro
		
		# Crear una nueva textura con la imagen modificada
		var texture = ImageTexture.create_from_image(img)
		layer.texture = texture
		
		# Redibujar el TextureRect
		layer.queue_redraw()

func _on_done_pressed() -> void:
	# Cambiar a la siguiente escena cuando se presiona el botón
	GameData.gameOver_On = true
	GameData.balance=1000
	GameData.boss_hide=false
	GameData.player_position = Vector2(-185,-35)
	print("Button pressed, changing scene...")
	get_tree().change_scene_to_file("res://scenes/Hall.tscn")
	
