extends KinematicBody2D

onready var _sprite = get_node("AnimatedSprite") as AnimatedSprite

class_name Player

export var speed := 100.0
export var health := 3

var test_time := 0.0

var _velocity : Vector2

func _ready():
	pass

	
func _move():
	self._velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		self._velocity.x += 1
		self._sprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		self._velocity.x -= 1
		self._sprite.flip_h = true
	if Input.is_action_pressed("ui_up"):
		self._velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		self._velocity.y += 1
	if Input.is_action_pressed("attack"):
		if self._sprite.flip_h:
			GameEvents.emit_attack(Vector2(self.position.x - 13, self.position.y + 5), 
			self._sprite.flip_h)
		else:
			GameEvents.emit_attack(Vector2(self.position.x + 13, self.position.y + 5), 
			self._sprite.flip_h)
	if Input.is_action_just_released("attack"):
		GameEvents.emit_attack_released()
	self._velocity = self._velocity.normalized() * self.speed
	if self._velocity.x == 0 and self._velocity.y == 0:
		self._sprite.play("idle")
	else:
		self._sprite.play("run")
	

func _physics_process(delta):
	self.test_time += delta
	if self.test_time >= 2:
		self.test_time = 0
		GameEvents.emit_signal("player_hit")
	_move()
	self._velocity = move_and_slide(self._velocity)


