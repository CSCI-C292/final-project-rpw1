extends Node2D


func _ready():
	pass


func _on_power_up_body_entered(body):
	if body is Player:
		GameEvents.emit_make_weapon_gold()
		self.visible = false
