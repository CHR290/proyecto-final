extends Node
var empresas_grandes_activas = []
var empresas_medianas_activas = []
var empresas_pequenas_activas = []
var dolares: float = 100
var empresa_actual: ResourceEmpresa = null
func _ready() -> void:
	Global.day_changed.connect(actualizar_empresas)
	cargar_recursos("res://resources/empresas")
	print("Empresas grandes activas: ", empresas_grandes_activas.size())
	print("Empresas medianas activas: ", empresas_medianas_activas.size())
	print("Empresas pequeñas activas: ", empresas_pequenas_activas.size())
	for empresa in empresas_grandes_activas:
		empresa.actualizar_valor(0)
	for empresa in empresas_medianas_activas:
		empresa.actualizar_valor(0)
	for empresa in empresas_pequenas_activas:
		empresa.actualizar_valor(0)

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
				if recurso:
					# clasificar por tipo de empresa
					match recurso.nivel:
						"Grande":
							empresas_grandes_activas.append(recurso)
						"Mediana":
							empresas_medianas_activas.append(recurso)
						"Pequeña":
							empresas_pequenas_activas.append(recurso)
				else:
					print("Error: No se pudo cargar el recurso en ", ruta_completa)			
			nombre_archivo = dir.get_next()
	else:
		print("Error: No se pudo acceder a la carpeta de trabajos en: ", ruta_carpeta)

func comprar_acciones(cantidad: float):
	empresa_actual.acciones_compradas += cantidad / empresa_actual.valor_accion
	dolares -= cantidad

func vender_acciones(cantidad: float):
	empresa_actual.acciones_compradas -= cantidad / empresa_actual.valor_accion
	dolares += cantidad

func actualizar_empresas():
	for empresa in empresas_grandes_activas:
		empresa.actualizar_valor(0)
	for empresa in empresas_medianas_activas:
		empresa.actualizar_valor(0)
	for empresa in empresas_pequenas_activas:
		empresa.actualizar_valor(0)
