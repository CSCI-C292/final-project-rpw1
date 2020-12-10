extends Node2D

signal attack(player_position, is_flipped)
signal player_hit
signal attack_released
signal player_vector(player_position, player_velocity)
signal get_player_vector
signal set_health(health_pos)
signal make_weapon_gold

# This function emits a signal that that the player touched an enemy.
func emit_enemy_touched() -> void:
	call_deferred("emit_signal", "player_hit")
	
func emit_attack(player_position: Vector2, is_flipped: bool) -> void:
	call_deferred("emit_signal", "attack", player_position, is_flipped)
	
func emit_attack_released() -> void:
	call_deferred("emit_signal", "attack_released")

func emit_player_vector(player_position: Vector2, player_velocity: Vector2) -> void:
	call_deferred("emit_signal", "player_vector", player_position, player_velocity)
	
func emit_get_player_vector() -> void:
	call_deferred("emit_signal", "get_player_vector")

func emit_set_health(health_pos: int) -> void:
	call_deferred("emit_signal", "set_health", health_pos)
	
func emit_make_weapon_gold() -> void:
	call_deferred("emit_signal", "make_weapon_gold")
