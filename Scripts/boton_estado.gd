extends TextureButton
@export var estado1: Texture2D
@export var estado2: Texture2D
@export var estado3: Texture2D
@export var estado4: Texture2D
@export var estado5: Texture2D

func _ready() -> void:
	cambiar_icono()
	Global.time_changed.connect(cambiar_icono)
	self.mouse_entered.connect(_on_mouse_entered)	
	self.mouse_exited.connect(_on_mouse_exited)
	self.button_down.connect(_on_button_down)
	self.button_up.connect(_on_button_up)

func _on_mouse_entered():
	self.self_modulate = Color(1.2,1.2,1.2,1)

func _on_mouse_exited():
	self.self_modulate = Color(1,1,1,1)	

func _on_button_down():
	self.self_modulate = Color(0.8,0.8,0.8,1)

func _on_button_up():
	self.self_modulate = Color(1,1,1,1)

func cambiar_icono():
	if Global.estado >= 80:
		self.texture_normal = estado5
	elif Global.estado >= 60:
		self.texture_normal = estado4
	elif Global.estado >= 40:
		self.texture_normal = estado3
	elif Global.estado >= 20:
		self.texture_normal = estado2
	else:
		self.texture_normal = estado1






		



