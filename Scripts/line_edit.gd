extends LineEdit
@export var tipo: int
@onready var line_edit = self
func _input(event: InputEvent) -> void:
	match tipo:
		0:
			if event is InputEventKey and event.pressed and event.keycode == KEY_F1:
				self.visible = !self.visible
		1:
			if event is InputEventKey and event.pressed and event.keycode == KEY_F2:
				self.visible = !self.visible
		2:
			if event is InputEventKey and event.pressed and event.keycode == KEY_F3:
				self.visible = !self.visible
func _on_text_submitted(new_text: String) -> void:
	match tipo:
		0:
			Global.lanzar_evento(load(Global.id_eventos[int(new_text)]))
		1:
			Global.day = int(new_text.substr(0, 2))
			Global.month = int(new_text.substr(2, 3))
			Global.advance_time(0,0,0,0)
		2:
			Global.hours = int(new_text.substr(0, 2))
			Global.minutes = int(new_text.substr(2, 3))
			Global.advance_time(0,0,0,0)


	line_edit.clear()
