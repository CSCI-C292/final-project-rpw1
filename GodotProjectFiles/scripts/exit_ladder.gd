extends Node2D

export(String, FILE, "*.tscn") var _next_level_path_1
export(String, FILE, "*.tscn") var _next_level_path_2

func _ready():
	pass

# This function starts the next level
func _on_exit_body_entered(body) -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if (rng.randf() < 0.5):
		get_tree().change_scene(self._next_level_path_1)
	else:
		get_tree().change_scene(self._next_level_path_2)
