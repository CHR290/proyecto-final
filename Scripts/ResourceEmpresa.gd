extends Resource
@export_group("Info")
@export var id: int = 0
@export var imagen: Texture2D
@export var nombre: String = ""
@export var descripcion: String = ""
@export var acciones: int = 0
@export_enum("Grande", "Mediana", "Pequeña") var nivel: String = "mediana"
@export_group("comportamiento")
@export var volatilidad_bajar: float = 0.0
@export var volatilidad_subir: float = 0.0
@export var tasa_dividendo: float = 0.0
@export_group("Estado")
@export var valor_total: int = 0
@export var valor_accion: int = 0
@export var variacion: int = 0

