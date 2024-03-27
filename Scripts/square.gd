extends ColorRect
class_name Square

# Create signal to emit when a square is clicked.
signal square_clicked(square)

# Export variables for square identifiers and states.
@export var id = -1
@export var file = -1
@export var rank = -1
@export var square_occupied = false
@export var piece = 0

func _init(r, f) -> void:
	name = Definitions.Squares.find_key(r * 8 + f)
	custom_minimum_size = Definitions.SQUARE_SIZE
	rank = 8 - r
	file = 1 + f
	id = r * 8 + f
	color = _set_square_color(r, f)
	square_occupied = false
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)

# Determine color of square based on position.
func _set_square_color(r, f) -> Color:
	if ((r + f) % 2) == 0:
		return Definitions.LIGHT_COLOR
	else:
		return Definitions.DARK_COLOR

# Change filter to show when mouse is hovered over.
func _on_mouse_entered() -> void:
	self_modulate = Color(1, 1, 1, 0.25)

# Change filter to not show when mouse exits.
func _on_mouse_exited() -> void:
	self_modulate = Color(1, 1, 1, 1)

# Detect if square was clicked on and emit square clicked signal.
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		emit_signal("square_clicked", self)
