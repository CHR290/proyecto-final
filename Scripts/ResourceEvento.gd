extends Resource
class_name EventResource

enum TipoControl { OPCIONES, SLIDER }

@export_group("Configuración del Evento")
@export var titulo: String = ""
@export_multiline var texto: String = ""
@export var imagen: Texture2D
@export var id: int
@export var cierra_menu: bool = true
@export_group("Botones")
@export var modo_control: TipoControl = TipoControl.OPCIONES
@export var opciones: Array[String] = ["Opción 1", "Opción 2"]
@export_group("Slider")
@export var cantidad_min: int = 0
@export var cantidad_max: int = 1000
@export var cantidad_por_defecto: int = 0
@export_group("Consecuencias")
@export var consecuencias: Array[String] = ["nada", "nada"]
@export_group("condiciones")
@export var limite_diario: int = 0
@export var horarios_validos: Array[Array] = [[0,12],[12,23]] 
@export var dias: Array[int] = [1,7] 
@export var fechas: Array[int] = [1,31]
@export var meses: Array[int] = [1,12]
@export var lugar: Array[String] = []
@export var accion: Array[String] = []
@export var gamestate: Array[String] = []
@export var probabilidad: float = 0.0 
@export var estado: int