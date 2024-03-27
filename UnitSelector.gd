extends Control

var is_visible = false
var m_pos = Vector2()
var start_pos = Vector2()

const SEL_BOX_COLOR = Color.CORNFLOWER_BLUE
const SEL_BOX_LINE_WIDTH = 4

func _draw():
	if is_visible and start_pos != m_pos:
		var rect := Rect2(Vector2(m_pos.x, m_pos.y), Vector2(start_pos.x - m_pos.x, start_pos.y - m_pos.y))
		draw_rect(rect, SEL_BOX_COLOR, false, SEL_BOX_LINE_WIDTH)

func _process(delta):
	queue_redraw()
