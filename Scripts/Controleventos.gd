extends Control
var recurso: EventResource
# Referencias a los nodos de UI
@onready var label_titulo = $Titulo
@onready var label_text = $Texto
@onready var rect_imagen = $Imagen
@onready var contenedor_botones = $Zona_interaccion/opciones
@onready var contenedor_slider = $Zona_interaccion/Slider
@onready var slider_cantidad = $Zona_interaccion/Slider/HSlider
@onready var label_slider = $Zona_interaccion/Slider/valor/Label
func configurar_evento(p_recurso: EventResource):
	recurso = p_recurso
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

func _crear_botones(p_recurso: EventResource):
	recurso = p_recurso
	for child in contenedor_botones.get_children():
		child.queue_free()	
	for i in range(recurso.opciones.size()):
		var button = Button.new()
		button.text = recurso.opciones[i]
		button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER	
		button.custom_minimum_size = Vector2(156, 44) 
		button.pressed.connect(_on_opcion_seleccionada.bind(i))
		contenedor_botones.add_child(button)
		
func _on_opcion_seleccionada(indice: int):
	var opcion_elegida: String
	var valor_slider = slider_cantidad.value
	opcion_elegida = recurso.consecuencias[indice]
	var consecuencias = opcion_elegida.split(",")
	for consecuencia in consecuencias:
		if consecuencia == "nada":
				Global.hay_evento_activo = false
				queue_free()
				Global.event_finished.emit()
				return
		var partes = consecuencia.split(":")
		var accion = str(partes[0])
		var valor
		if accion == "activar gamestate" or "desactivar gamestate":
			valor = partes[1]
		else:
			valor = int(partes[1])			
		match accion:
			"quitar dinero":
				Global.change_money(-valor)
			"ganar dinero":
				Global.change_money(valor)
			"quitar dinero slider":
				Global.change_money(-valor_slider)
			"ganar dinero slider":
				Global.change_money(valor_slider)
			"avanzar tiempo":
				Global.advance_time(0,0,0,valor)
			"activar gamestate":
				Global.gamestates[valor] = true
			"desactivar gamestate":
				Global.gamestates[valor] = false
			"lanzar evento":
				var ruta_evento = Global.id_eventos[valor]
				var recurso_evento = load(ruta_evento)
				Global.hay_evento_activo = false
				queue_free()
				Global.event_finished.emit()
				Global.lanzar_evento(recurso_evento)
				return
	Global.hay_evento_activo = false
	queue_free()
	Global.event_finished.emit()
