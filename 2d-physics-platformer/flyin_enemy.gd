extends CharacterBody2D

@export var speed: float = 150.0
@export var start_direction: String = "right"

var direction: int = 1
var is_dying := false

@onready var ray_right: RayCast2D = $RayCastRight
@onready var ray_left: RayCast2D = $RayCastLeft
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
 if start_direction == "left":
  direction = -1
  sprite.flip_h = true

func _physics_process(delta: float) -> void:
 # Если монстр умирает, просто заставляем его падать
 if is_dying:
  rotation += 10.0 * delta
  velocity.y += 800.0 * delta
  move_and_slide()
  return

 # Логика патрулирования (разворот от лучей)
 if direction == 1 and ray_right.is_colliding():
  direction = -1
  sprite.flip_h = true
 elif direction == -1 and ray_left.is_colliding():
  direction = 1
  sprite.flip_h = false

 velocity.x = direction * speed
 velocity.y = 0
 
 # Двигаем монстра
 move_and_slide()
 
 # ПРОВЕРКА СТОЛКНОВЕНИЯ С ПУЛЕЙ (как у оригинального врага)
 # Проверяем все объекты, с которыми монстр пересекся на этом кадре
 for i in get_slide_collision_count():
  var collision := get_slide_collision(i)
  var collider := collision.get_collider()
  
  # Используем встроенный класс Bullet из шаблона!
  if collider is Bullet and not (collider as Bullet).disabled:
   _die_from_bullet(collider)
   break

# Функция смерти, полностью скопированная по логике из оригинального enemy.gd
func _die_from_bullet(bullet_node: Bullet) -> void:
 is_dying = true
 
 # Выключаем пулю, как это делал наземный враг
 bullet_node.disable() 
 
 # Отключаем коллизию монстра, чтобы он падал сквозь пол и не мешал игроку
 $CollisionShape2D.queue_free()
 
 # Воспроизводим звук попадания (он глобальный или встроен в сцену уровня)
 # Если у тебя на сцене монстра есть звук, можно раскомментировать:
 # $SoundHit.play()
 
 # Даем ему полсекунды покрутиться в падении и удаляем
 await get_tree().create_timer(0.5).timeout
 queue_free()
