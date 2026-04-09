extends Control
var money: int = 5000

func _ready():
	update_money_display()

# Esta función actualiza el texto en pantalla
func update_money_display():
	$contador_efectivo/cantidad_dinero.text = str(money)

# Llama a esta función cada vez que el jugador gane dinero
func change_money(amount: int):
	money += amount
	update_money_display()
