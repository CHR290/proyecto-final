extends Node
signal money_changed(new_amount)
signal time_changed
signal event_triggered

var id_eventos = {
	1001: "res://Events/Evento1.tres",
	1002: "res://Events/Evento2.tres",
	1003: "res://Events/Evento3.tres",
	1004: "res://Events/Evento4.tres",
	1005: "res://Events/Evento5.tres"
}

var evento: String = ""
var money: int = 7000

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
	while minutes >= 60:
		minutes -= 60
		hours += 1
	hours += h
	while hours >= 24:
		hours -= 24
		day += 1
		weekday += 1
		if weekday > 7:
			weekday = 1
		# indicador.mover_indicador(weekday - 1)
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
	evento = ruta_recurso
	event_triggered.emit()
