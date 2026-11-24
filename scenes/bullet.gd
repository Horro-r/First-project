extends Area2D

@export var speed: float = 300.0 #Скорость полета пули
var direction: Vector2 = Vector2.ZERO #Куда летит

func _ready(): #(чтобы не путаться с кнопками)
	body_entered.connect(_on_body_entered)
#движение пули
func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body): #если пуля коснулась врага
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free() #удалить пулю
