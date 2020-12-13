extends KinematicBody2D

class_name Enemy

onready var _sprite = get_node("AnimatedSprite") as AnimatedSprite

var _velocity: Vector2
var _chasing := false
var _player_position: Vector2
export var speed := 85.0
var _player_veloctiy: Vector2

func _ready():
	GameEvents.connect("player_vector", self, "player_vector_update")


func _physics_process(delta):
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
		
# This function gets the difference of the player and the boss
# Then it moves the boss 5 delta's ahead of the player
func get_move_vel(delta) -> void:
	var difference_vector = self._player_position - self.position
	difference_vector = difference_vector + (self._player_veloctiy * delta * 5)
	self._velocity = difference_vector

# This function starts the boss to chase the player
func _on_Area2D_body_entered(body) -> void:
	if body is Player:
		self._chasing = true

# This function ends the boss to chase the player
func _on_Area2D_body_exited(body) -> void:
	if body is Player:
		self._chasing = false
		
# This function gets the player's velocity and position
func player_vector_update(player_vector: Vector2, player_velocity: Vector2) -> void:
	self._player_position = player_vector
	self._player_veloctiy = player_velocity

# This function sends a singal to remove the health from the player
func _on_Area2DHitBox_body_entered(body) -> void:
	if body is Player:
		GameEvents.emit_enemy_touched()
