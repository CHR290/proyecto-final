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
@onready var slider = $Zona_interaccion/Slider/HSlider
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
				slider.step = 1000
			-1:
				slider_cantidad.max_value = Global.dinero_banco
				slider.step = 1000
			-2:
				slider_cantidad.max_value = Inversiones.dolares * 4000
				slider.step = 1000
			-3:
				slider_cantidad.max_value = Inversiones.dolares
				slider.step = 0.1
			-4:
				slider_cantidad.max_value = Inversiones.empresa_actual.acciones_compradas * Inversiones.empresa_actual.valor_accion
				slider.step = 0.01
			-5:
				if Global.score_crediticio >= 800:
					slider_cantidad.max_value = 1000000
				elif Global.score_crediticio >= 600:
					slider_cantidad.max_value = 500000
				elif Global.score_crediticio >= 400:
					slider_cantidad.max_value = 200000
				else:
					slider_cantidad.max_value = 0
				slider.step = 1000
			_:
				slider_cantidad.max_value = recurso.cantidad_max
		slider_cantidad.value = recurso.cantidad_por_defecto
		match recurso.tipo_texto:
			0:
				slider_cantidad.value_changed.connect(func(v):label_slider.text = "$" + str(int(v)))
			1:
				slider_cantidad.value_changed.connect(func(v): label_slider.text = "USD " + str(int(v)*0.00025) + " ($" + str(int(v)) + ")")
			2:
				slider_cantidad.value_changed.connect(func(v): label_slider.text = str(snapped(v/Inversiones.empresa_actual.valor_accion, 0.01)) + " ($" + str(v) + ")")		
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
		var valor_f: float
		valor_f = float(partes[1])
		valor = int(partes[1])
		var valor_str = partes[1]
		
		match accion:
			"quitar dinero":
				if verificar_dinero(valor):
					Global.hay_evento_activo = false
					queue_free()
					Global.event_finished.emit()
					Global.lanzar_evento(recurso.id)
					return
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
							Global.change_money_credit(valor)
			"ganar dinero efectivo":
				if valor_str == "slider":
					Global.change_money(valor_slider)
				else:
					Global.change_money(valor)
			"quitar dinero efectivo":
				if valor_str == "slider":
					Global.change_money(-valor_slider)
				else:
					Global.change_money(-valor)
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
				Global.multiplicador_cortisol += valor * 0.01
			"bajar cortisol":
				Global.multiplicador_cortisol -= valor * 0.01
			"subir salud":
				Global.multiplicador_salud += valor * 0.01
			"bajar salud":
				Global.multiplicador_salud -= valor * 0.01
			"subir felicidad":
				Global.multiplicador_felicidad += valor * 0.01
			"bajar felicidad":
				Global.multiplicador_felicidad -= valor * 0.01
			"dar objeto":
				Global.inventory.append(valor_str)
			"quitar objeto":
				Global.inventory.erase(valor_str)
			"añadir ahorro":
				Global.dinero_ahorrado += valor_slider
				Global.change_money_bank(-valor_slider)
			"tiempo ahorro":
				Global.tiempo_ahorro = valor
			"bonificacion ahorro":
				Global.bonificacion_ahorro = valor_f
			"retiro de emergencia":
				var penalizacion: float
				match Global.bonificacion_ahorro:
					1.1:
						penalizacion = 0.9
					1.4:
						penalizacion = 0.8
					1.7:
						penalizacion = 0.7
					2.0:
						penalizacion = 0.5
				var pago_penalizado: float = Global.dinero_ahorrado * penalizacion
				Global.change_money_bank(int(pago_penalizado))
				Global.dinero_ahorrado = 0
				Global.score_crediticio -= 50
			"comprar dolares":
				Inversiones.dolares += valor_slider * 0.00025
				Global.change_money_bank(-valor_slider)
			"vender dolares":
				Inversiones.dolares -= valor_slider * 0.00025
				Global.change_money_bank(valor_slider)
			"comprar acciones":
				Inversiones.comprar_acciones(valor_slider)
			"vender acciones":
				Inversiones.vender_acciones(valor_slider)
			"prestamo":
				Global.change_money_bank(valor_slider)
				Global.gamestates["prestamo activo"] = true
				if valor_slider > 500000:
					Global.tiempo_prestamo = 90
				elif valor_slider > 200000:
					Global.tiempo_prestamo = 60
				else:
					Global.tiempo_prestamo = 30		
				Global.valor_prestamo = valor_slider
			"pagar prestamo":
				var pago: int
				if Global.score_crediticio >= 800:
					pago = int(Global.valor_prestamo * 1.1)
				elif Global.score_crediticio >= 600:
					pago = int(Global.valor_prestamo * 1.4)
				else:
					pago = int(Global.valor_prestamo * 1.5)
				Global.change_money_bank(-pago)
				Global.gamestates["prestamo activo"] = false
				Global.score_crediticio += 50
			"set salud":
				Global.salud = 0
				Global.lanzar_evento(5678765)
	Global.hay_evento_activo = false
	queue_free()
	Global.event_finished.emit()

func verificar_dinero(valor: int) -> bool :
	match Global.pago_activo:
		0:
			if valor > Global.dinero_efectivo:
				return true
		1:
			if valor > Global.dinero_banco:
				return true
		3:
			if valor > Global.dinero_credito:
				return true
	return false
