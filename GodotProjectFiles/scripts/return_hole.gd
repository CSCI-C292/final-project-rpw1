extends Node2D


export(String, FILE, "*.tscn") var _past_level_path

# This function sets the player at the scene previous
func _on_return_body_entered(body) -> void:
	get_tree().change_scene(self._past_level_path)
