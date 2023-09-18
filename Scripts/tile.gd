extends Sprite2D

@onready var label = get_node("Label")
var lastValue: int
var value: int
var color: Color = getColorForValue(2)


func _ready():
	pass


func _draw():
	draw_rect(Rect2(Vector2(0, 0), Vector2(32, 32)), color)


func _process(_delta):
	if lastValue != value:
		lastValue = value
		updateTile(value)


func updateTile(val: int):
	self.value = val
	label.set_text(str(val))
	color = getColorForValue(val)
	queue_redraw()


func getColorForValue(val = 2) -> Color:
	var cases = {
		2: hexToColor(0xeee4da),
		4: hexToColor(0xede0c8),
		8: hexToColor(0xf2b179),
		16: hexToColor(0xf59563),
		32: hexToColor(0xf67c5f),
		64: hexToColor(0xf65e3b),
		128: hexToColor(0xedcf72),
		256: hexToColor(0xedcc61),
		512: hexToColor(0xedc850),
		1024: hexToColor(0xedc53f),
		2048: hexToColor(0xedc22e),
	}
	return cases[val]


func hexToColor(hex: int) -> Color:
	var red = ((hex >> 16) & 0xFF) / 255.0
	var green = ((hex >> 8) & 0xFF) / 255.0
	var blue = (hex & 0xFF) / 255.0
	return Color(red, green, blue)
