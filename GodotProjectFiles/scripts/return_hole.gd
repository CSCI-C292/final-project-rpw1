extends Node2D


export(String, FILE, "*.tscn") var _past_level_path

func _ready():
	pass
	


func _on_return_body_entered(body):
	get_tree().change_scene(self._past_level_path)
