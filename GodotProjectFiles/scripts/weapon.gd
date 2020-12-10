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
	
func _attack(delta):
	if self._is_attacking:
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

func _start_attack(player_position: Vector2, is_flipped: bool) -> void:
	if self._is_attack_released:
		self._is_attacking = true
		self._is_attack_released = false
	self._player_position = player_position
	self._player_fliped = is_flipped
	self._saved_x = player_position.x
	

func _attack_released():
	self._is_attack_released = true

func _on_weapon_body_entered(body):
	if body is Player and self._runtime_data.current_weapon_state != GameState.WeaponState.GOLDEN_WEAPON:
		self.visible = false
		self._runtime_data.current_weapon_state = GameState.WeaponState.NORMAL_WEAPON
	if body is Enemy and self._weapon_sprite.visible:
		body.queue_free()
	
func _make_weapon_gold():
	self._runtime_data.current_weapon_state = GameState.WeaponState.GOLDEN_WEAPON
