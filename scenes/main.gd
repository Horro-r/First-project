extends Node2D

@export var slime_scene: PackedScene 

@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer

func _ready():
	#сигнал таймера 
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if player != null and slime_scene != null:
		var slime = slime_scene.instantiate()
		
		# Спавним слайма по кругу на расстоянии 300 пикселей от игрока
		var angle = randf() * TAU # Случайный угол
		var distance = 100.0
		slime.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * distance
		
		add_child(slime)
