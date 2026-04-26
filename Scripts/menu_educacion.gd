extends Control
@export var fila: PackedScene
@onready var contenedor_filas = $ScrollContainer/VBoxContainer
@onready var scroll = $ScrollContainer
var activos: bool = false # Estado de la pestaña actual

func _ready() -> void:
	actualizar_tabla()
	$switch.pressed.connect(on_switch_pressed)
	Global.day_changed.connect(actualizar_tabla)

func actualizar_tabla() -> void:
	for child in contenedor_filas.get_children():
		child.queue_free() 
	var lista = []
	if activos:
		lista = Global.cursos_activos
	else:
		lista = Global.cursos_disponibles
	for curso in lista:	
		if not activos and not Global.curso_cumple_requisitos(curso):
			continue
		var fila_nueva = fila.instantiate()
		contenedor_filas.add_child(fila_nueva)
		fila_nueva.configurar(curso, activos)
		fila_nueva.get_node("Button").pressed.connect(_on_fila_pressed.bind(curso))
func on_switch_pressed():
	activos = !activos
	actualizar_tabla()
	scroll.scroll_vertical = 0

func _on_fila_pressed(curso: ResourceCurso):
	if activos:
		Global.salir_curso(curso)
	else:
		Global.entrar_curso(curso)
	actualizar_tabla()

func _gui_input(event):
	var altura_fila = 36 	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			scroll.scroll_vertical -= altura_fila
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			scroll.scroll_vertical += altura_fila
