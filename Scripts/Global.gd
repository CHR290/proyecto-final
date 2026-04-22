extends Node
signal money_changed(new_amount)
signal time_changed
signal event_triggered
signal menu_changed(menu_id)
@warning_ignore("unused_signal")
signal event_finished

var menu_actual: int = 0

var schedule = []

var gamestates = {
	"vivenda padres": false,
	"vivienda propia": false,
	"vehículo": false,
	"mascota": false,
	"trabajo con jefe": false
	}

var hay_evento_activo: bool = false

var id_eventos = {
	1001: "res://Events/Evento1.tres",
	1002: "res://Events/Evento2.tres",
	1003: "res://Events/Evento3.tres",
	1004: "res://Events/Evento4.tres",
	1005: "res://Events/Evento5.tres"
	}

var registro_eventos = {}

var evento: String = ""

var money: int = 100000
var experience: int = 1
var education: Array[String] = []
var inventory: Array[String] = []
var lugar_actual: String = ""

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
	for d in range(7):
		var dia = []
		for h in range(24):
			dia.append(0)
		schedule.append(dia)
	entrar_curso(load("res://resources/Cursos/Secundaria.tres")) 
	cursos_activos[0].dias_asistidos = 239

func actualizar_informacion_diaria():
	registro_eventos.clear()
	for curso in cursos_activos:
		if curso.dias_asistidos >= curso.duracion_dias:
			education.append(curso.nombre)
			cursos_activos.erase(curso)
			mark_schedule(curso.horario[0], curso.horario[1], curso.dias_semana, false)
		else:
			curso.dias_asistidos += 1
	if day == 2 or day == 16:	
		quincena()

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
			if schedule[dia_index-1][h] == 1:
				return false
	return true

func mark_schedule(inicio: int, fin: int, dias: Array, ocupado: bool):
	for d in range(dias[0], dias[1]+1):
		for h in range(inicio, fin):
			schedule[d-1][h] = 1 if ocupado else 0

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
			# siguiente archivo
			nombre_archivo = dir.get_next()
	else:
		print("Error: No se pudo acceder a la carpeta de trabajos en: ", ruta_carpeta)

func contratar_trabajo(trabajo: ResourceTrabajo) -> bool:
	if horario_libre(trabajo.horario[0], trabajo.horario[1], trabajo.dias_semana):
		trabajos_disponibles.erase(trabajo)
		trabajos_activos.append(trabajo)
		mark_schedule(trabajo.horario[0], trabajo.horario[1], trabajo.dias_semana, true)
		return true
	return false

func renunciar_trabajo(trabajo: ResourceTrabajo):
	trabajos_activos.erase(trabajo)
	trabajos_disponibles.append(trabajo)
	mark_schedule(trabajo.horario[0], trabajo.horario[1], trabajo.dias_semana, false)

func entrar_curso(curso: ResourceCurso):
		cursos_disponibles.erase(curso)
		cursos_activos.append(curso)
		mark_schedule(curso.horario[0], curso.horario[1], curso.dias_semana, true)

func salir_curso(curso: ResourceCurso):
	curso.dias_asistidos = 0
	cursos_activos.erase(curso)
	cursos_disponibles.append(curso)
	mark_schedule(curso.horario[0], curso.horario[1], curso.dias_semana, false)

func trabajo_cumple_requisitos(trabajo: ResourceTrabajo) -> bool:
	if Global.experience < trabajo.experiencia:
		return false
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
	money += value
	money_changed.emit(money)

func advance_time(mo: int, d: int, h: int, m: int):
	minutes += m
	if speed < 4:
		try_evento()
	while minutes >= 60:
		minutes -= 60
		hours += 1
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
	elif month in [4, 6, 9, 11]:
		while day > 30:
			day -= 30
			month += 1
	else:		
		while day > 31:
			day -= 31
			month += 1	
	
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

func lanzar_evento(ruta_recurso: EventResource):
	if !hay_evento_activo:
		evento = ruta_recurso.resource_path
		event_triggered.emit()
		hay_evento_activo = true
		speed = 0
		
func try_evento():
	var eventos_posibles = []
	for id in id_eventos.keys():
		var recurso = load(id_eventos[id])
		if _cumple_condiciones(id, recurso):
			eventos_posibles.append({"id": id, "resource": recurso})
	if eventos_posibles.size() > 0:
		var evento_elegido = eventos_posibles.pick_random()
		var probabilidad: float
		if speed < 4:
			probabilidad = 1.0-((1-evento_elegido["resource"].probabilidad)**(1.0/60.0))
		else:
			probabilidad = evento_elegido["resource"].probabilidad
		if randf() <= probabilidad:
			lanzar_evento(evento_elegido["resource"])
			registrar_evento(evento_elegido["id"])
			
func _cumple_condiciones(id: int, recurso: EventResource) -> bool:
	if recurso.limite_diario > 0:
		var apariciones = registro_eventos.get(id, 0)
		if apariciones >= recurso.limite_diario:
			return false
	if recurso.lugar != "" and recurso.lugar != lugar_actual:
		return false
	if recurso.dias.size() > 0 and weekday not in recurso.dias:
		return false
	if recurso.fechas.size() > 0 and day not in recurso.fechas:
		return false
	if recurso.meses.size() > 0 and month not in recurso.meses:
		return false
	if recurso.gamestate.size() > 0:
		for state in recurso.gamestate:
			if gamestates.get(state, false) == false:
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
