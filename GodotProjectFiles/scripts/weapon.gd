extends Node2D

var _is_attacking := false
var _player_position: Vector2
var _player_fliped := false
var _saved_x := 0.0
var _attack_time := 0.0
var _MAX_ATTACK := 0.1
var _is_attack_released := true
export(Resource) var _runtime_data = _runtime_data as RuntimeData
onready var _weapon_sprite = get_node("WeponSprite") as Sprite
var _weapon_sprite_resource = preload("res://AssetFiles/0x72_DungeonTilesetII_v1.3.1/frames/weapon_golden_sword.png")
onready var _weapon_colission = get_node("WeponSprite/Area2D/CollisionShape2D")

func _ready():
	GameEvents.connect("attack", self, "_start_attack")
	GameEvents.connect("attack_released", self, "_attack_released")
	GameEvents.connect("make_weapon_gold", self, "_make_weapon_gold")

func _process(delta):
	if self._runtime_data.current_weapon_state == GameState.WeaponState.NO_WEAPON:
		self.visible = true
	else:
		self.rotation_degrees = 90
		self.visible = false
		self._attack(delta)
	if self._runtime_data.current_weapon_state == GameState.WeaponState.GOLDEN_WEAPON:
		self._weapon_sprite.texture = self._weapon_sprite_resource
	
# This function checks if the player is attacking.
# If the player is attacking, it will start the swords hitbox and
# makes it visible for 0.1 seconds.
func _attack(delta) -> void:
	if self._is_attacking:
		self._weapon_colission.set_deferred("disabled", false)
		self.visible = true
		if self._player_fliped:
			self._weapon_sprite.flip_v = true
		else:
			self._weapon_sprite.flip_v = false
		self.position.x = self._player_position.x
		self.position.y = self._player_position.y
		self._attack_time += delta
		if self._attack_time >= self._MAX_ATTACK:
			self._attack_time = 0
			self.visible = false
			self._is_attack_released
			self.position.x = self._saved_x
			self._is_attacking = false
	else:
		self._weapon_colission.set_deferred("disabled", true)

# This function sets the correct variables to start the attack animation.
func _start_attack(player_position: Vector2, is_flipped: bool) -> void:
	if self._is_attack_released:
		self._is_attacking = true
		self._is_attack_released = false
	self._player_position = player_position
	self._player_fliped = is_flipped
	self._saved_x = player_position.x
	
# This function is connected to a signal to indicate that the player released
# the attack button.
func _attack_released() -> void:
	self._is_attack_released = true

# This function checks what body the sword hitbox has touched.
func _on_weapon_body_entered(body) -> void:
	if body is Player and self._runtime_data.current_weapon_state != GameState.WeaponState.GOLDEN_WEAPON:
		self.visible = false
		self._runtime_data.current_weapon_state = GameState.WeaponState.NORMAL_WEAPON
	elif body is Enemy and self._weapon_sprite.visible:
		body.queue_free()
	elif body is Boss:
		GameEvents.emit_boss_hit(self._runtime_data)
	
# This function upgrades the current weapon.
func _make_weapon_gold() -> void:
	self._runtime_data.current_weapon_state = GameState.WeaponState.GOLDEN_WEAPON
