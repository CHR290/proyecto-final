extends Control
# Referencias a los nodos de UI
@onready var label_titulo = $Titulo
@onready var label_text = $Texto
@onready var rect_imagen = $Imagen
@onready var contenedor_botones = $Zona_interaccion/opciones
@onready var contenedor_slider = $Zona_interaccion/Slider
@onready var slider_cantidad = $Zona_interaccion/Slider/HSlider
@onready var label_slider = $Zona_interaccion/Slider/valor/Label
func configurar_evento(recurso: EventResource):
	label_titulo.text = recurso.titulo
	label_text.text = recurso.texto
	rect_imagen.texture = recurso.imagen
	if recurso.modo_control == EventResource.TipoControl.OPCIONES:
		contenedor_slider.hide()
	else:
		contenedor_slider.show()
		slider_cantidad.min_value = recurso.cantidad_min
		slider_cantidad.max_value = recurso.cantidad_max
		slider_cantidad.value = recurso.cantidad_por_defecto
		slider_cantidad.value_changed.connect(func(v): label_slider.text = "$" + str(v))
	_crear_botones(recurso)

func _crear_botones(recurso: EventResource):
	for child in contenedor_botones.get_children():
		child.queue_free()	
	for i in range(recurso.opciones.size()):
		var button = Button.new()
		button.text = recurso.opciones[i]
		button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER	
		button.custom_minimum_size = Vector2(156, 44) 
		button.pressed.connect(_on_opcion_seleccionada.bind(i, slider_cantidad.value))
		contenedor_botones.add_child(button)

func _on_opcion_seleccionada(indice: int, valor_slider: float):
	print("Opción elegida: ", indice, " con valor: ", valor_slider)
	queue_free() 
