extends Node




# IDs de los perros
const DOG_IDS = [1, 2, 3, 4, 5, 6, 7, 8]

# Variables globales
var bet_dog_id : int = -1  # ID del perro apostado (-1 significa ninguna apuesta)
var bet_amount : float = 0.0  # Cantidad apostada por el usuario
var balance : float = 0  # Saldo inicial del jugador
var race_winner : int = -1  # ID del perro ganador
var won_bet : bool = false  # Indica si la apuesta fue ganada o no
var bet_amounts : Dictionary = {}  # Apuestas por perro {perro_id: cantidad_apostada}
var payout_rates : Array = [1.5, 3.0, 3.0, 2.0, 2.0, 3.0, 5.0, 15.0]  # Multiplicadores por cada perro
var boss_hide: bool = true
var gameOver_On: bool = false
var drink_overdose: int = 0
var her_love = 0

# Resultados de la carrera
var race_results : Array = []  # Lista con los resultados de la carrera

# Variable global para la posición del personaje
var player_position : Vector2 = Vector2(0, 0)  # Coordenadas (X, Y) del personaje

var music_pos : float = 0.0

var boss_music_cont : bool = false
