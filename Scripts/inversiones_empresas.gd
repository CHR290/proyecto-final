extends Control
var tipo_empresa = "grande"
var tamaño_lista: int
var indice_empresa = 0
var empresa: ResourceEmpresa
func _ready() -> void:
	actualizar_interfaz()
	Global.day_changed.connect(actualizar_interfaz)
	Global.event_finished.connect(actualizar_interfaz)
func actualizar_interfaz():	
	var variacion: float
	match tipo_empresa:		
		"grande":
			empresa = Inversiones.empresas_grandes_activas[indice_empresa]
			tamaño_lista = Inversiones.empresas_grandes_activas.size()
		"mediana":
			empresa = Inversiones.empresas_medianas_activas[indice_empresa]
			tamaño_lista = Inversiones.empresas_medianas_activas.size()
		"pequeña":
			empresa = Inversiones.empresas_pequenas_activas[indice_empresa]
			tamaño_lista = Inversiones.empresas_pequenas_activas.size()
	Inversiones.empresa_actual = empresa
	if empresa.variacion >= 0:
		variacion = empresa.variacion * 100
		$InfoEmpresa/Valor/Variacion.self_modulate = Color(0, 1, 0)
		$InfoEmpresa/Valor/Indicador.self_modulate = Color(0, 1, 0)
		$InfoEmpresa/Valor/Indicador.flip_v = true
	else:
		variacion = -empresa.variacion * 100
		$InfoEmpresa/Valor/Variacion.self_modulate = Color(1, 0, 0)
		$InfoEmpresa/Valor/Indicador.self_modulate = Color(1, 0, 0)
		$InfoEmpresa/Valor/Indicador.rotation_degrees = 0
		$InfoEmpresa/Valor/Indicador.flip_v = false
	$Dolares/Cantidad.text = "$ " + str(Inversiones.dolares) + " USD"
	$LogoEmpresa.texture = empresa.imagen
	$NombreEmpresa.text = empresa.nombre
	$Descripcion.text = empresa.descripcion
	$InfoEmpresa/Valor/Valor.text = "$" + str(empresa.valor_total) + " USD"
	$InfoEmpresa/Valor/Variacion.text = str(snapped(variacion, 0.01)) + "%"
	var acciones = empresa.acciones_compradas
	if !(acciones - int(acciones) > 0):
		acciones = str(int(acciones))
	else :
		acciones = str(snapped(acciones, 0.01))
	$InfoEmpresa/Acciones.text = "Acciones: " + str(empresa.acciones) + " (" + str(acciones) + ")"
	$InfoEmpresa/ValorAcciones.text = "Valor: $" + str(snapped(empresa.valor_accion, 0.01)) + " USD"
	$InfoEmpresa/Dividendos.text = "Dividendo: " + str(int(empresa.tasa_dividendo*100)) + " %"


func _on_nivel_pressed() -> void:
	match tipo_empresa:
		"grande":
			tipo_empresa = "mediana"
			indice_empresa = 0
			$Tamaño.text = "Medianas"
		"mediana":
			tipo_empresa = "pequeña"
			indice_empresa = 0
			$Tamaño.text = "Pequeñas"
		"pequeña":
			tipo_empresa = "grande"
			indice_empresa = 0
			$Tamaño.text = "Grandes"
	actualizar_interfaz()


func _on_siguiente_pressed() -> void:
	indice_empresa += 1
	if indice_empresa >= tamaño_lista:
		indice_empresa = 0
	actualizar_interfaz()

func _on_anterior_pressed() -> void:
	indice_empresa -= 1
	if indice_empresa < 0:
		indice_empresa = tamaño_lista - 1
	actualizar_interfaz()

func _on_comprar_dolares_pressed() -> void:
	Global.lanzar_evento(13)
	
func _on_vender_dolares_pressed() -> void:
	Global.lanzar_evento(14)

func _on_comprar_pressed() -> void:
	Global.lanzar_evento(11)


func _on_vender_pressed() -> void:
	Global.lanzar_evento(12)
	
