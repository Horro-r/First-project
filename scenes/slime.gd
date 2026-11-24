extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D # Ссылка на картинку 

@export var speed: float = 30.0
@export var damage: int = 10 # Сколько урона наносит
var player: Node2D
var can_attack: bool = true # Переменная для кулдауна (КД)


func _ready():
	player = get_tree().get_first_node_in_group("player")
	# Подключаем сигнал касания игрока
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		if velocity.x > 0:
			sprite.play("walk_right")
		# Если движемся влево
		elif velocity.x < 0:
			sprite.play("walk_left")
		

func _on_hitbox_body_entered(body):
	if body.is_in_group("player") and can_attack:
		body.take_damage(damage) # Бьем игрока
		can_attack = false       # Отключить возможность бить
	
		# 1 сек и разрешение бить
		await get_tree().create_timer(1.0).timeout 
		can_attack = true

func take_damage():
	queue_free() # Слайм умирает, когда в него попадает пуля
