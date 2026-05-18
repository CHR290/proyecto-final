extends Control

func _ready() -> void:
	pass 

func _on_empresas_pressed() -> void:
	Global.menu_changed.emit(7)

