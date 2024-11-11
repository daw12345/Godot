# DogParameters.gd
extends Resource

class_name DogParameters  # Esto permite usar DogParameters como tipo en otros scripts

@export var base_speed : float
@export var max_speed : float
@export var min_speed : float
@export var acceleration_rate : float
@export var fluctuation_rate : float
@export var change_delay : float
@export var fluctuation_burst_chance : float
@export var fluctuation_burst_duration : float
@export var burst_impulse : float = 7.5 
