extends CharacterBody2D
@onready var anim = $AnimatedSprite2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 1.0 
var shoot_timer: float = 0.0
var hp: int = 100 

const SPEED = 60.0
const JUMP_VELOCITY = -400.0

func _physics_process(_delta: float) -> void:
	# Получаем направление сразу с нормализацией (для WASD)
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
	# Задаем скорость и двигаем
	velocity = direction * SPEED
	move_and_slide()
	
	# код стрельбы (оставь как было)
	shoot_timer -= _delta
	if shoot_timer <= 0:
		shoot()
		shoot_timer = fire_rate

# Логика анимации
	if direction != Vector2.ZERO:
		# Если движемся влево/вправо (по иксу больше, чем по игреку)
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				anim.play("walk_right") 
			else:
				anim.play("walk_left")
		# Если движемся вверх/вниз
		else:
			if direction.y > 0:
				anim.play("walk_down")
			else:
				anim.play("walk_up")
	else:
		# Если игрок стоит на месте
		anim.stop() 


func shoot():
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.is_empty():
		return 
	
	#поиск ближайшего врага
	var closest_enemy = enemies[0]
	for e in enemies:
		if global_position.distance_to(e.global_position) < global_position.distance_to(closest_enemy.global_position):
			closest_enemy = e
			
	# создание пули
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.direction = (closest_enemy.global_position - global_position).normalized()
	get_tree().current_scene.add_child(bullet)


func take_damage(amount: int):
	hp -= amount
	print("Игрок получил урон! Осталось ХП: ", hp)
	if hp <= 0:
		print("Игрок умер!")
		# Тут потом сделаю экран смерти



	
