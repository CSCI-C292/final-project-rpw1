extends KinematicBody2D

export(String, FILE, "*.tscn") var _end_game_path

var health : int = 6
var _velocity: Vector2
var chasing := false
var _player_position: Vector2
export var speed := 50.0
var _player_veloctiy: Vector2

var hurt_time := 0.0
const MAX_HURT_TIME := 1.0
var is_invincible := false

var FAST_MOVE_TIME = 5.0
var buffer_time = 0.0

var can_fast_move = false
var MAX_MOVE_TIME = 0.25
var move_time = 0.0

class_name Boss

onready var _sprite = get_node("AnimatedSprite") as AnimatedSprite

func _ready():
	GameEvents.connect("player_vector", self, "player_vector_update")
	GameEvents.connect("boss_hit", self, "take_damage")

func _physics_process(delta):
	if self.can_fast_move:
		move_and_slide(self._velocity * 5)
		self.move_time += delta
		if self.move_time > self.MAX_MOVE_TIME:
			self.can_fast_move = false
			self.move_time = 0
	
	if self.is_invincible:
		self.hurt_time += delta
		var invin_val = self.hurt_time / (3*delta)
		if (int(invin_val) - invin_val) == 0:
			self._sprite.visible = not self._sprite.visible
		if self.hurt_time > self.MAX_HURT_TIME:
			self.is_invincible = false
			self.hurt_time = 0
			self._sprite.visible = true
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
	
	if not self.can_fast_move:
		self.buffer_time += delta
		if self.buffer_time > self.FAST_MOVE_TIME:
			self.buffer_time = 0
			self.can_fast_move = true

# This function starts the boss to chase the player
func _on_boss_body_entered(body) -> void:
	if body is Player:
		self.chasing = true

# This function ends the boss to chase the player
func _on_boss_body_exited(body) -> void:
	if body is Player:
		self.chasing = false
		
# This function gets the difference of the player and the boss
# Then it moves the boss 5 delta's ahead of the player
func get_move_vel(delta) -> void:
	var difference_vector = self._player_position - self.position
	difference_vector  = difference_vector + (self._player_veloctiy * delta * 5)
	self._velocity = difference_vector
	
# This function gets the player's velocity and position
func player_vector_update(player_vector: Vector2, player_velocity: Vector2) -> void:
	self._player_position = player_vector
	self._player_veloctiy = player_velocity
	
# This function removes the boss's health depending on the weapon used
# This function starts the boss's invisibility frames
func take_damage(weapon_state) -> void:
	if not self.is_invincible:
		if weapon_state.current_weapon_state == GameState.WeaponState.NORMAL_WEAPON:
			self.health -= 1
		elif weapon_state.current_weapon_state == GameState.WeaponState.GOLDEN_WEAPON:
			self.health -= 2
		if self.health <= 0:
			get_tree().change_scene(self._end_game_path)
		else:
			self.is_invincible = true
	

# This function sends a singal to remove the health from the player
func _on_Area2DHitBox_body_entered(body) -> void:
	if body is Player:
		GameEvents.emit_enemy_touched()
