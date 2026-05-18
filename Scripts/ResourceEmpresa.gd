class_name ResourceEmpresa
extends Resource
@export_group("Info")
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
@export var valor_accion: float = 0
@export var pago_dividendo: float = 0
@export var variacion: float = 0
@export var acciones_compradas: float = 0

func actualizar_valor(extra: float) -> void:
    if extra == 0:
        var variacion_aleatoria = randf_range(-volatilidad_bajar, volatilidad_subir)
        var nuevo_valor = valor_total*(1 + variacion_aleatoria)
        valor_total = int(nuevo_valor)
    else:
        valor_total = int(valor_total * extra)
    valor_accion = float(valor_total) / acciones
    pago_dividendo = (valor_accion * acciones_compradas) * tasa_dividendo



    
        
    

