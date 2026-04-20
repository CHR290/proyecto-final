extends Resource
class_name ResourceCurso

@export var nombre: String
@export var duracion_meses: int
@export var horario: Array[int]
@export var dias_semana: Array[int]
@export var costo_semestre: int
@export_group("Requisitos")
@export var educacion: Array[String]
#------------------------------------
var duracion_dias: int:
    get: return duracion_meses * 30
var dias_asistidos: int = 0
var progeso: float:
    get: return (float(dias_asistidos) / float(duracion_dias)) * 100.0

