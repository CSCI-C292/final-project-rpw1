extends KinematicBody2D

var health : int = 6
var _velocity: Vector2
var chasing := false
var _player_position: Vector2
export var speed := 50.0
var _player_veloctiy: Vector2

var hurt_time := 0.0
const MAX_HURT_TIME := 1.0
var is_invincible := false

class_name Boss

onready var _sprite = get_node("AnimatedSprite") as AnimatedSprite

func _ready():
	GameEvents.connect("player_vector", self, "player_vector_update")

func _physics_process(delta):
	if self.is_invincible:
		self.hurt_time += delta
		if self.hurt_time >= self.MAX_HURT_TIME:
			self.is_invincible = false
			self.hurt_time = 0
	if self.chasing:
		
		self._sprite.play("run")
		GameEvents.emit_get_player_vector()
		get_move_vel(delta)
		if self._velocity.x < 0:
			self._sprite.flip_h = true
		else:
			self._sprite.flip_h = false
		self._velocity = self._velocity.normalized() * self.speed
		move_and_slide(self._velocity)
	else:
		self._sprite.play("idle")

func _on_boss_body_entered(body):
	if body is Player:
		self.chasing = true


func _on_boss_body_exited(body):
	if body is Player:
		self.chasing = false
		
func get_move_vel(delta):
	var difference_vector = self._player_position - self.position
	print(difference_vector)
	difference_vector  = difference_vector + (self._player_veloctiy * delta * 5)
	self._velocity = difference_vector
	
func player_vector_update(player_vector: Vector2, player_velocity: Vector2):
	self._player_position = player_vector
	self._player_veloctiy = player_velocity
