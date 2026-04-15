extends Node
signal money_changed(new_amount)
signal time_changed
signal event_triggered
@warning_ignore("unused_signal")
signal event_finished

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

var money: int = 7000

var lugar_actual: String = "habitacion"

var hours: int = 8
var minutes: int = 0
var day: int = 1
var month: int = 1
var year: int = 2024
var weekday: int = 1 
var speed: int = 0 
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
		registro_eventos.clear()
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
			print(month)
	else:		
		while day > 31:
			day -= 31
			month += 1	
	
	month += mo
	while month > 12:
		month -= 12
		year += 1

	emit_signal("time_changed")

func lanzar_evento(ruta_recurso: String):
	if !hay_evento_activo:
		evento = ruta_recurso
		event_triggered.emit()
		hay_evento_activo = true
		speed = 0
		
func try_evento():
	var eventos_posibles = []
	for id in id_eventos.keys():
		var recurso = load(id_eventos[id])
		if _cumple_condiciones(recurso):
			eventos_posibles.append(recurso)
	if eventos_posibles.size() > 0:
		var evento_elegido = eventos_posibles.pick_random()
		var probablidiad: float
		if speed < 4:
			probablidiad = 1.0-((1-evento_elegido.probabilidad)**(1.0/60.0))
		else:
			probablidiad = evento_elegido.probabilidad
		if randf() <= probablidiad:
			lanzar_evento(evento_elegido.resource_path)
func _cumple_condiciones(recurso: EventResource) -> bool:
	if recurso.lugar != "" and recurso.lugar != lugar_actual:
		return false
	if recurso.dias.size() > 0 and weekday not in recurso.dias:
		return false
	if recurso.fechas.size() > 0 and day not in recurso.fechas:
		return false
	if recurso.meses.size() > 0 and month not in recurso.meses:
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
