extends Node
signal money_changed
signal time_changed
signal event_triggered
signal menu_changed(menu_id)
signal day_changed
signal place_changed
@warning_ignore("unused_signal")
signal event_finished
@warning_ignore("unused_signal")
signal minute_passed

var menu_actual: int = 0

var horario = []

var gamestates = {
	"vivenda padres": false,
	"vivienda propia": false,
	"vehículo": false,
	"mascota": false,
	"trabajo con jefe": false,
	"tabajo": false,
	"ahorro activo": false
	}

var hay_evento_activo: bool = false

var id_eventos = {}

var registro_eventos = {}

var eventos_activados: bool = true

var evento: String = ""

var pago_activo: int = 0
var dinero_credito = 0
var dinero_efectivo: int = 100000
var dinero_banco: int = 0
var dinero_total: int:	 
	get: return dinero_efectivo + dinero_banco
var dinero_ahorrado: int
var tiempo_ahorro: int
var bonificacion_ahorro: float
var score_crediticio = 400

var gastos_mensuales = {

	}

var education: Array[String] = []
var inventory: Array[String] = []

var cortisol: int = 10
var felicidad: int = 100
var salud: int = 100
var estado: int = 100

var lugar_actual: String = "casa"
var accion_actual: String = "nada"

var time_accumulator: float = 0.0
var hours: int = 15
var minutes: int = 0
var day: int = 14
var month: int = 9
var year: int = 2024
var weekday: int = 1 
var speed: int = 0 

var trabajos_activos: Array[ResourceTrabajo] = []
var trabajos_disponibles: Array[ResourceTrabajo] = []

var cursos_activos: Array[ResourceCurso] = []
var cursos_disponibles: Array[ResourceCurso] = []

func _ready():
	cargar_recursos("res://resources/Trabajos")
	cargar_recursos("res://resources/Cursos")
	cargar_recursos("res://events")
	for d in range(7):
		var dia = []
		for h in range(24):
			dia.append("libre")
		horario.append(dia)
	var curso_inicial = load("res://resources/Cursos/Secundaria.tres")
	entrar_curso(curso_inicial)
	cursos_disponibles.erase(curso_inicial) 
	cursos_activos[0].dias_asistidos = 239

func _process(delta):
	
	# Definimos cuántos minutos de juego pasan por cada segundo real
	var minutes_per_second: float = 0.0
	match speed:
		0: minutes_per_second = 0.0     # Pausado
		1: minutes_per_second = 1.0     # 1 min/seg
		2: minutes_per_second = 10.0    # 10 min/seg
		3: minutes_per_second = 60.0    # 1 hora/seg
		4: minutes_per_second = 1440.0  # 1 día/seg
	
	# Acumulamos el tiempo transcurrido
	time_accumulator += delta * minutes_per_second
	
	# Mientras el acumulador tenga al menos 1 minuto entero...
	while time_accumulator >= 1.0:
		advance_time(0, 0, 0, 1) # Avanzamos de 1 en 1 minuto
		minute_passed.emit()
		time_accumulator -= 1.0

func actualizar_informacion_diaria():
	registro_eventos.clear()
	actualizar_cursos()
	if day == 2 or day == 16:	
		quincena()
	day_changed.emit()
	actualizar_ahorro()

func actualizar_informacion_mensual():
	for gasto in gastos_mensuales.values():
		change_money(-gasto)

func quincena():
	for trabajo in trabajos_activos:
		var horas_trabajadas
		var horas_dia = trabajo.horario[1] - trabajo.horario[0]
		var horas_semana = horas_dia*(trabajo.dias_semana[1] - trabajo.dias_semana[0] + 1)
		var pago
		horas_trabajadas = horas_semana*2
		pago = int(horas_trabajadas*trabajo.paga_por_hora)		
		change_money(pago)

func gestionar_menu(menu_id: int):
	menu_changed.emit(menu_id)

func horario_libre(inicio: int, fin: int, dias: Array) -> bool:
	for dia in range(dias[0], dias[1]+1):
		var dia_index = dia - 1
		for h in range(inicio, fin):
			if horario[dia_index-1][h] != "libre":
				return false
	return true

func mark_schedule(inicio: int, fin: int, dias: Array, marca: String):
	for d in range(dias[0], dias[1]+1):
		for h in range(inicio, fin):
			horario[d-1][h] = marca 

func cargar_recursos(ruta_carpeta: String):
	# acceso a la carpeta
	var dir = DirAccess.open(ruta_carpeta)
	if dir:
		# listar los archivos
		dir.list_dir_begin()
		var nombre_archivo = dir.get_next()
		while nombre_archivo != "":
			# archivos .tres 
			if !dir.current_is_dir() and nombre_archivo.ends_with(".tres"):
				var ruta_completa = ruta_carpeta + "/" + nombre_archivo
				var recurso = load(ruta_completa)			
				# verificar que sea ResourceTrabajo
				if recurso is ResourceTrabajo:
					# añadir a la lista
					if not trabajos_disponibles.has(recurso):
						trabajos_disponibles.append(recurso)			
				# verificar que sea ResourceCurso
				if recurso is ResourceCurso:
					# añadir a la lista
					if not cursos_disponibles.has(recurso):
						cursos_disponibles.append(recurso)		
				if recurso is EventResource:
					if not id_eventos.has(recurso):
						id_eventos[recurso.id] = ruta_completa
			# siguiente archivo
			nombre_archivo = dir.get_next()
	else:
		print("Error: No se pudo acceder a la carpeta de trabajos en: ", ruta_carpeta)

func contratar_trabajo(trabajo: ResourceTrabajo) -> bool:
	if horario_libre(trabajo.horario[0], trabajo.horario[1], trabajo.dias_semana):
		trabajos_disponibles.erase(trabajo)
		trabajos_activos.append(trabajo)
		var trabajo_nombre: String = "T"+trabajo.nombre
		mark_schedule(trabajo.horario[0], trabajo.horario[1], trabajo.dias_semana, trabajo_nombre)
		return true
	return false

func renunciar_trabajo(trabajo: ResourceTrabajo):
	trabajos_activos.erase(trabajo)
	trabajos_disponibles.append(trabajo)
	mark_schedule(trabajo.horario[0], trabajo.horario[1], trabajo.dias_semana, "libre")

func entrar_curso(curso: ResourceCurso):
		cursos_disponibles.erase(curso)
		cursos_activos.append(curso)
		mark_schedule(curso.horario[0], curso.horario[1], curso.dias_semana, "C"+curso.nombre)

func salir_curso(curso: ResourceCurso):
	curso.dias_asistidos = 0
	cursos_activos.erase(curso)
	cursos_disponibles.append(curso)
	mark_schedule(curso.horario[0], curso.horario[1], curso.dias_semana, "libre")

func trabajo_cumple_requisitos(trabajo: ResourceTrabajo) -> bool:
	if trabajo.educacion.size() > 0:
		for edu in trabajo.educacion:
			if edu not in Global.education:
				return false
	if trabajo.objetos.size() > 0:
		for obj in trabajo.objetos:
			if obj not in Global.inventory:
				return false
	if trabajo.gamesates.size() > 0:
		for state in trabajo.gamesates:
			if gamestates.get(state, false) == false:
				return false
	return true

func curso_cumple_requisitos(curso: ResourceCurso) -> bool:
	if curso.educacion.size() > 0:
		for edu in curso.educacion:
			if edu not in Global.education:
				return false
	return true

func change_money(value: int): 
	dinero_efectivo += value
	money_changed.emit()

func change_money_bank(value: int):
	dinero_banco += value
	money_changed.emit()

func change_money_credit(value:int):
	dinero_credito += value
	money_changed.emit()

func advance_time(mo: int, d: int, h: int, m: int):
	minutes += m
	if speed < 4:
		try_evento()
	while minutes >= 60:
		minutes -= 60
		hours += 1
		actualizar_informacion_hora()
		if speed == 4:
			try_evento()
	hours += h
	while hours >= 24:
		hours -= 24
		day += 1
		actualizar_informacion_diaria()
		weekday += 1
		if weekday > 7:
			weekday = 1
	day += d
	if month == 2:
		while day > 28:
			day -= 28
			month += 1
			actualizar_informacion_mensual()
	elif month in [4, 6, 9, 11]:
		while day > 30:
			day -= 30
			month += 1
			actualizar_informacion_mensual()
	else:		
		while day > 31:
			day -= 31
			month += 1	
			actualizar_informacion_mensual()
	
	month += mo
	while month > 12:
		month -= 12
		year += 1

	emit_signal("time_changed")

func registrar_evento(id: int):
	if registro_eventos.has(id):
		registro_eventos[id] += 1
	else:
		registro_eventos[id] = 1

func lanzar_evento(id: int):
	var event = load(Global.id_eventos[id])
	if !hay_evento_activo:
		evento = event.resource_path
		event_triggered.emit()
		hay_evento_activo = true
		speed = 0
		if event.cierra_menu:
			gestionar_menu(menu_actual)
		
func try_evento():
	if eventos_activados == false:
		return
	var eventos_posibles = []
	for id in id_eventos.keys():
		var recurso = load(id_eventos[id])
		print("Evaluando evento: ", id, " con recurso: ", recurso)
		if _cumple_condiciones(id, recurso):
			eventos_posibles.append({"id": id, "resource": recurso})
		print("Evento ", id, " cumple condiciones: ", _cumple_condiciones(id, recurso))
	if eventos_posibles.size() > 0:
		var evento_elegido = eventos_posibles.pick_random()
		var probabilidad: float
		if speed < 4:
			probabilidad = 1.0-((1-evento_elegido["resource"].probabilidad)**(1.0/60.0))
		else:
			probabilidad = evento_elegido["resource"].probabilidad
		if randf() <= probabilidad:
			lanzar_evento(evento_elegido["id"])
			registrar_evento(evento_elegido["id"])
	print("Eventos posibles: ", eventos_posibles.size())
			
func _cumple_condiciones(id: int, recurso: EventResource) -> bool:
	if recurso.limite_diario > 0:
		var apariciones = registro_eventos.get(id, 0)
		if apariciones >= recurso.limite_diario:
			print("error 1")
			return false
	if recurso.dias.size() > 0 and weekday not in recurso.dias:
		print("error 2")
		return false
	if recurso.fechas.size() > 0 and day not in range(recurso.fechas[0], recurso.fechas[1]):
		print("error 3")
		return false
	if recurso.meses.size() > 0 and month not in range(recurso.meses[0], recurso.meses[1]):
		print("error 4")
		return false
	if recurso.gamestate.size() > 0:
		for state in recurso.gamestate:
			if gamestates.get(state, false) == false:
				print("error 5")
				return false
	if recurso.lugar.size() != 0:
		for lugar in recurso.lugar:
			if lugar == lugar_actual:
				return true
	if recurso.accion.size() != 0:
		for accion in recurso.accion:
			if accion == accion_actual:
				return true
		print("error 6")
		return false
	var hora_valida = false
	if recurso.horarios_validos.size() == 0:
		hora_valida = true
	else:
		for rango in recurso.horarios_validos:
			if hours >= rango[0] and hours <= rango[1]:
				hora_valida = true
				break
	return hora_valida

func imprimir_horario():
	for i in range(0,24):
		var linea: String = ""
		for accion in horario:
			linea += accion[i]
			for espacio in range(0, 14-accion[i].length()):
				linea += " "
		print(linea)
		linea = ""

func actualizar_cursos():
	for curso in cursos_activos:
		if curso.dias_asistidos >= curso.duracion_dias:
			education.append(curso.nombre)
			cursos_activos.erase(curso)
			mark_schedule(curso.horario[0], curso.horario[1], curso.dias_semana, "libre")
			var graduacion = load("res://Events/grado_"+curso.nombre.to_lower()+".tres")
			lanzar_evento(graduacion.id)
						
		else:
			curso.dias_asistidos += 1	

func actualizar_informacion_hora():
	actualizar_lugar()

func actualizar_lugar():
	var hora_objetivo
	if hours == 24:
		hora_objetivo = 0
	else:
		hora_objetivo = hours	
	var accion_objetivo: String = horario[weekday-1][hora_objetivo]
	if !(accion_objetivo == accion_actual):
		var recurso
		accion_actual = accion_objetivo
		if accion_actual.begins_with("T"):
			recurso = load("res://resources/Trabajos/"+accion_actual.erase(0)+".tres")
			lugar_actual = recurso.lugar
		elif accion_actual.begins_with("C"):
			recurso = load("res://resources/cursos/"+accion_actual.erase(0)+".tres")
			lugar_actual = recurso.lugar
		else:
			lugar_actual = "casa"
		place_changed.emit()
		
func actualizar_ahorro():
	if gamestates["ahorro activo"]:
		tiempo_ahorro -= 1
		if tiempo_ahorro == 0:
			print(dinero_ahorrado * bonificacion_ahorro)
			var pago_ahorro: float = dinero_ahorrado * bonificacion_ahorro
			change_money_bank(int(pago_ahorro))
			gamestates["ahorro_activo"] = false
