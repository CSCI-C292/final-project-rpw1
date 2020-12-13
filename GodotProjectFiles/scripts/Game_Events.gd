extends Node2D

signal attack(player_position, is_flipped)
signal player_hit
signal attack_released
signal player_vector(player_position, player_velocity)
signal get_player_vector
signal set_health(health_pos)
signal make_weapon_gold
signal boss_hit(weapon_state)

# This function emits a signal that the player touched an enemy.
func emit_enemy_touched() -> void:
	call_deferred("emit_signal", "player_hit")
	
# This function emits a signal that the player starts an attack.
func emit_attack(player_position: Vector2, is_flipped: bool) -> void:
	call_deferred("emit_signal", "attack", player_position, is_flipped)
	
# This function emits a signal that the player releases an attack.
func emit_attack_released() -> void:
	call_deferred("emit_signal", "attack_released")

# This function emits a signal that sends the player position and velocity
func emit_player_vector(player_position: Vector2, player_velocity: Vector2) -> void:
	call_deferred("emit_signal", "player_vector", player_position, player_velocity)
	
# This function emits a signal for the player to send its position and velocity
func emit_get_player_vector() -> void:
	call_deferred("emit_signal", "get_player_vector")

# This function emits the health's current position of the player
func emit_set_health(health_pos: int) -> void:
	call_deferred("emit_signal", "set_health", health_pos)
	
# This signal updates the player's weapon to gold
func emit_make_weapon_gold() -> void:
	call_deferred("emit_signal", "make_weapon_gold")
	
# The function emits the current weapon when the sword hitbox touches the boss
func emit_boss_hit(weapon_state) -> void:
	call_deferred("emit_signal", "boss_hit", weapon_state)
