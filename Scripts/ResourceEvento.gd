extends Resource
class_name EventResource

enum TipoControl { OPCIONES, SLIDER }

@export_group("Configuración del Evento")
@export var titulo: String = ""
@export_multiline var texto: String = ""
@export var imagen: Texture2D
@export var id: int
@export_group("Botones")
@export var modo_control: TipoControl = TipoControl.OPCIONES
@export var opciones: Array[String] = ["Opción 1", "Opción 2"]
@export_group("Slider")
@export var cantidad_min: float = 0.0
@export var cantidad_max: float = 1000.0
@export var cantidad_por_defecto: float = 0.0
@export_group("Consecuencias")
@export var ids_consecuencia: Array[String] = ["nada", "nada"]
@export var valores: Array[int] = [0, 0, 0, 0]
@export_group("condiciones")
@export var limite_diario: int = 0
@export var horarios_validos: Array[Array] = [] 
@export var dias: Array[int] = [] 
@export var fechas: Array[int] = []
@export var meses: Array[int] = []
@export var lugar: String = ""
@export var gamestate: Array[String] = []
@export var probabilidad: float = 0.0 
