extends Node2D

signal attack(player_position, is_flipped)
signal weapon_touched
signal player_hit
signal attack_released

# This function emits a signal that that the player touched an enemy.
func emit_enemy_touched() -> void:
	call_deferred("emit_signal", "player_hit")
	
func emit_attack(player_position: Vector2, is_flipped: bool) -> void:
	call_deferred("emit_signal", "attack", player_position, is_flipped)

func emit_weapon_touched() -> void:
	call_deferred("emit_signal", "weapon_touched")
	
func emit_attack_released() -> void:
	call_deferred("emit_signal", "attack_released")
