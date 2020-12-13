extends Node2D

# This function makes the players weapon gold if they touched the power up.
func _on_power_up_body_entered(body) -> void:
	if body is Player:
		GameEvents.emit_make_weapon_gold()
		self.visible = false
