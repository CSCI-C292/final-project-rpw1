extends KinematicBody2D

onready var _sprite = get_node("AnimatedSprite") as AnimatedSprite
export(Resource) var _runtime_data = _runtime_data as RuntimeData

class_name Player

export var speed := 100.0

var hurt_time := 0.0
var MAX_HURT_TIME := 1.0
var is_invincible := false

var _velocity : Vector2

func _ready():
	GameEvents.connect("get_player_vector", self, "send_player_vector")
	GameEvents.connect("player_hit", self, "_invincible_animate")
	GameEvents.emit_set_health(self._runtime_data.current_health)

# This function moves the player depending on what keyboard button was pressed.
func _move() -> void:
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
	if self.is_invincible:
		self.hurt_time += delta
		var invin_val = self.hurt_time / (3*delta)
		if (int(invin_val) - invin_val) == 0:
			self._sprite.visible = not self._sprite.visible
		if self.hurt_time > self.MAX_HURT_TIME:
			self.is_invincible = false
			self.hurt_time = 0
			self._sprite.visible = true
	_move()
	self._velocity = move_and_slide(self._velocity)

# This function sends the players position and velocity.
func send_player_vector() -> void:
	GameEvents.emit_player_vector(self.position, self._velocity)

# This function removes the players health by one and starts invinciblity frames
func _invincible_animate() -> void:
	self._runtime_data.current_health -= 1
	self.hurt_time = 0
	self.is_invincible = true
	


