extends Camera2D

# Enum para definir los modos de cámara
enum CameraMode { GLOBAL_VIEW, LEADER_VIEW, FOLLOW_DOG }
var camera_mode = CameraMode.GLOBAL_VIEW  # Comenzamos en la vista global
var previous_mode = CameraMode.GLOBAL_VIEW  # Para comparar y solo imprimir cuando cambie el modo

# Lista de perros
var dogs = []  
var current_dog_index = 0  # Índice del perro que estamos siguiendo

# Propiedades de zoom para cada modo
var global_zoom = Vector2(0.5, 0.5)  # Zoom más alejado para la vista global
var leader_zoom = Vector2(0.7, 0.7)  # Zoom normal para la vista del líder
var follow_dog_zoom = Vector2(1.0, 1.0)  # Zoom normal para la vista del perro

# Desplazamiento de la cámara en la vista global
var global_camera_offset = 0.0  # Desplazamiento horizontal en la vista global
var global_camera_speed = 600.0  # Velocidad de movimiento de la cámara
var camera_y_offset = -50.0  # Desplazamiento vertical en el eje Y para elevar la cámara

func _ready():
	# Limpiar la lista de perros antes de llenarla
	dogs.clear()

	# Verificar los hijos de la escena actual (escena principal donde están los perros)
	for node in get_parent().get_children():
		if node is Node2D and node.name.begins_with("Dog") and node != self:  # Filtrar solo los nodos de tipo Node2D y que comiencen con "Dog", excluyendo la cámara
			dogs.append(node)  # Añadir perro a la lista

	# Asegurarnos de que al menos hay un perro para seguir
	if dogs.size() > 0:
		current_dog_index = 0  # Seguimos al primer perro por defecto
	else:
		print("¡No se encontraron perros en la escena!")

	# Imprimir los perros detectados
	print("Perros detectados: ", dogs.size())

	# Inicializamos la cámara con el zoom adecuado para el modo inicial
	update_camera_zoom()

func _process(delta):
	# Cambiar entre los modos de cámara con las teclas 1, 2 y 3
	if Input.is_action_just_pressed("mode_1"):  # Tecla 1
		change_camera_mode(CameraMode.GLOBAL_VIEW)
	elif Input.is_action_just_pressed("mode_2"):  # Tecla 2
		change_camera_mode(CameraMode.LEADER_VIEW)
	elif Input.is_action_just_pressed("mode_3"):  # Tecla 3
		change_camera_mode(CameraMode.FOLLOW_DOG)
	
	# Cambiar entre los perros en el modo FOLLOW_DOG con las teclas A y D
	if camera_mode == CameraMode.FOLLOW_DOG:
		if Input.is_action_just_pressed("change_left"):  # Tecla A
			previous_dog()
		elif Input.is_action_just_pressed("change_right"):  # Tecla D
			next_dog()

	# Mover la cámara en el modo GLOBAL_VIEW con las teclas de izquierda y derecha
	if camera_mode == CameraMode.GLOBAL_VIEW:
		if Input.is_action_pressed("ui_left"):  # Tecla izquierda
			global_camera_offset -= (global_camera_speed * delta)*2
		elif Input.is_action_pressed("ui_right"):  # Tecla derecha
			global_camera_offset += (global_camera_speed * delta)*2

	# Lógica según el modo de la cámara
	match camera_mode:
		CameraMode.GLOBAL_VIEW:
			# Lógica para la vista global
			if dogs.size() > 0:
				var global_center = Vector2(global_camera_offset, 0)  # Desplazamos la cámara a lo largo del eje X
				position = global_center + Vector2(0, camera_y_offset)  # Ajuste en el eje Y

		CameraMode.LEADER_VIEW:
			# Lógica para seguir al perro líder (el que ha avanzado más en la carrera)
			if dogs.size() > 0:
				var leader_dog = get_leader_dog()  # Buscar el perro líder
				position = leader_dog.position + Vector2(0, camera_y_offset)  # Ajuste en el eje Y

		CameraMode.FOLLOW_DOG:
			# Lógica para seguir un perro específico según current_dog_index
			if dogs.size() > 0 and current_dog_index < dogs.size():
				var dog_to_follow = dogs[current_dog_index]  # Perro a seguir
				position = dog_to_follow.position + Vector2(0, camera_y_offset)  # Ajuste en el eje Y

	# Aplicar el zoom apropiado dependiendo del modo
	update_camera_zoom()

# Cambiar el modo de la cámara
func change_camera_mode(new_mode: CameraMode):
	if new_mode != previous_mode:  # Solo cambiar si es un modo diferente
		camera_mode = new_mode  # Cambiar el modo actual de la cámara
		previous_mode = new_mode  # Actualizar el modo anterior

# Función para cambiar el zoom de la cámara según el modo
func update_camera_zoom():
	match camera_mode:
		CameraMode.GLOBAL_VIEW:
			zoom = global_zoom  # Zoom alejado para la vista global
		CameraMode.LEADER_VIEW:
			zoom = leader_zoom  # Zoom normal para el líder
		CameraMode.FOLLOW_DOG:
			zoom = follow_dog_zoom  # Zoom normal para el perro

# Función para cambiar al siguiente perro
func next_dog():
	if dogs.size() > 1:
		current_dog_index = (current_dog_index + 1) % dogs.size()  # Cambiar al siguiente perro en la lista

# Función para cambiar al perro anterior
func previous_dog():
	if dogs.size() > 1:
		current_dog_index = (current_dog_index - 1 + dogs.size()) % dogs.size()  # Cambiar al perro anterior

# Función para obtener al perro líder (el que tiene la mayor posición en el eje X)
func get_leader_dog() -> Node2D:
	var leader_dog : Node2D = dogs[0]
	for dog in dogs:
		if dog.position.x > leader_dog.position.x:
			leader_dog = dog
	return leader_dog
