extends Node2D

export(String, FILE, "*.tscn") var _next_level_path

func _ready():
	pass


func _on_exit_body_entered(body):
	get_tree().change_scene(self._next_level_path)
