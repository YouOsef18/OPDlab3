extends Area2D

# Сила, с которой батут будет швырять игрока вверх
@export var bounce_force: float = 600.0

func _ready() -> void:
 # Подключаем встроенный сигнал: когда какое-то тело входит в зону батута
 body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
 # Проверяем, что в батут врезался именно наш класс Player
 if body is Player:
  # Нам нужно передать импульс в физический поток игрока.
  # Для RigidBody2D безопаснее всего менять скорость через call_deferred
  body.call_deferred(&"apply_trampoline_bounce", bounce_force)
  
  # Если у батута будет анимация сжатия/прыжка, можно запустить её здесь:
  # if has_node("AnimationPlayer"): $AnimationPlayer.play("bounce")
