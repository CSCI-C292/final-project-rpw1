extends KinematicBody2D

class_name Enemy

onready var _sprite = get_node("AnimatedSprite") as AnimatedSprite

var _velocity: Vector2
var _chasing := false
var _player_position: Vector2
export var speed := 70.0
var _player_veloctiy: Vector2

var hurt_time := 0.0
const MAX_HURT_TIME := 1.0
var is_invincible := false


func _ready():
	GameEvents.connect("player_vector", self, "player_vector_update")


func _physics_process(delta):
	if self.is_invincible:
		self.hurt_time += delta
		if self.hurt_time >= self.MAX_HURT_TIME:
			self.is_invincible = false
			self.hurt_time = 0
	if self._chasing:
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
		

func get_move_vel(delta):
	var difference_vector = self._player_position - self.position
	difference_vector = difference_vector + (self._player_veloctiy * delta * 5)
	self._velocity = difference_vector

func _on_Area2D_body_entered(body):
	if body is Player:
		self._chasing = true


func _on_Area2D_body_exited(body):
	if body is Player:
		self._chasing = false
		
func player_vector_update(player_vector: Vector2, player_velocity: Vector2):
	self._player_position = player_vector
	self._player_veloctiy = player_velocity


func _on_Area2DHitBox_body_entered(body):
	if not self.is_invincible and body is Player:
		GameEvents.emit_enemy_touched()
		self.is_invincible = true
	else:
		self.is_invincible = false
