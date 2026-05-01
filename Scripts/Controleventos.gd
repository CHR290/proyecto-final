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
		match recurso.cantidad_max:
			0:
				slider_cantidad.max_value = Global.dinero_efectivo
			-1:
				slider_cantidad.max_value = Global.dinero_banco
			_:
				slider_cantidad.max_value = recurso.cantidad_max
		slider_cantidad.value = recurso.cantidad_por_defecto
		slider_cantidad.value_changed.connect(func(v): label_slider.text = "$" + str(int(v)))
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
		var valor: int
		valor = int(partes[1])
		var valor_str = partes[1]
		
		match accion:
			"quitar dinero":
				if valor_str == "slider":
					match Global.pago_activo:
						0:
							Global.change_money(-valor_slider)
						1:
							Global.change_money_bank(-valor_slider)
						3:
							Global.change_money_credit(-valor_slider)
				else:
					match Global.pago_activo:
						0:
							Global.change_money(-valor)
						1:
							Global.change_money_bank(-valor)
						3:
							Global.change_money_credit(-valor)
			"ganar dinero":
				if valor_str == "slider":
					match Global.pago_activo:
						0:
							Global.change_money(valor_slider)
						1:
							Global.change_money_bank(valor_slider)
						3:
							Global.change_money_credit(valor_slider)
				else:
					match Global.pago_activo:
						0:
							Global.change_money(valor)
						1:
							Global.change_money_bank(valor)
						3:
							Global.change_money_bank(valor)
			"ganar dinero efectivo":
				if valor_str == "slider":
					Global.change_money(-valor_slider)
				else:
					Global.change_money(-valor)
			"quitar dinero efectivo":
				if valor_str == "slider":
					Global.change_money(valor_slider)
				else:
					Global.change_money(valor)
			"retirar banco":
				if valor_str == "slider":
					Global.change_money_bank(-valor_slider)
				else:
					Global.change_money_bank(-valor)
			"depositar banco":
				if valor_str == "slider":
					Global.change_money_bank(valor_slider)
				else:
					Global.change_money_bank(valor)
			"quitar dinero credito":
				if valor_str == "slider":
					Global.change_money_credit(valor)
				else:
					Global.change_money_credit(valor)

			"avanzar tiempo":
				Global.advance_time(0,0,0,valor)
			"activar gamestate":
				Global.gamestates[valor_str] = true
			"desactivar gamestate":
				Global.gamestates[valor_str] = false
			"abrir menu":
				Global.gestionar_menu(valor)
			"lanzar evento":
				Global.hay_evento_activo = false
				queue_free()
				Global.event_finished.emit()
				Global.lanzar_evento(valor)
				return
			"subir cortisol":
				Global.cortisol += valor
			"bajar cortisol":
				Global.cortisol -= valor
			"subir salud":
				Global.cortisol += valor
			"bajar salud":
				Global.cortisol -= valor
			"subir felicidad":
				Global.felicidad += valor
			"bajar felicidad":
				Global.felicidad -= valor
			"dar objeto":
				Global.inventory.append(valor_str)
			"quitar objeto":
				Global.inventory.erase(valor_str)
	Global.hay_evento_activo = false
	queue_free()
	Global.event_finished.emit()
