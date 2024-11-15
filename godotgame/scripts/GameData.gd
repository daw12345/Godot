extends Node

var bet_dog_id : int = -1  # ID del perro apostado (-1 significa ninguna apuesta)
var bet_amount : float = 0.0  # Cantidad apostada
var balance : float = 1000.0  # Saldo inicial del jugador
var race_winner : int = -1  # ID del perro ganador
var won_bet : bool = false  # Indica si la apuesta fue ganada o no
