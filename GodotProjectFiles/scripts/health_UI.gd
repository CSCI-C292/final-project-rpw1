extends Control

export var _health := 2
var _health_position := 2
onready var _health_container = get_node("HealthContainer") as HBoxContainer
var hit := false

func _ready():
	GameEvents.connect("player_hit", self, "_remove_health")
	
func _remove_health():
	if self._health_position > -1:
		var current_heart = self._health_container.get_child(self._health_position) as TextureRect
		self._health_position -= 1
		current_heart.visible = false
