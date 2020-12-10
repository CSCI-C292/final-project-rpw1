extends Control

export var _health := 2
var _health_position := 2
onready var _health_container = get_node("HealthContainer") as HBoxContainer

export(String, FILE, "*.tscn") var _game_over_path

func _ready():
	GameEvents.connect("player_hit", self, "_remove_health")
	GameEvents.connect("set_health", self, "_set_health")
	
func _remove_health():
	if self._health_position > -1:
		var current_heart = self._health_container.get_child(self._health_position) as TextureRect
		if not current_heart.visible and self._health_position == 1:
			current_heart = self._health_container.get_child(self._health_position - 1) as TextureRect
		self._health_position -= 1
		current_heart.visible = false
		
	if self._health_position == -1:
		get_tree().change_scene(self._game_over_path)

func _set_health(health_pos : int) -> void:
	self._health_position = health_pos
	for i in range(health_pos, self._health):
		var current_heart = self._health_container.get_child(i) as TextureRect
		current_heart.visible = false
