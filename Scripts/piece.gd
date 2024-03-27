extends TextureRect
class_name Piece

# Create signal to emit when piece is clicked.
signal piece_clicked(piece)

# Export variables for piece identifiers.
@export var type = 1
@export var piece_color = 1
@export var square_id = -1
@export var move_count = 0

# Initialize piece size and icon(texture).
func _ready() -> void:
	custom_minimum_size = Definitions.SQUARE_SIZE
	texture = load("res://Assets/" + _get_piece_name(type) + ".png")

# Create and return a piece from FEN characters.
static func create_from_fen(s) -> Piece:
	var piece = Piece.new()
	match s:
		"p":
			piece.type = Definitions.Pieces.Pawn
			piece.piece_color = Definitions.Colors.Black
		"P":
			piece.type = Definitions.Pieces.Pawn
			piece.piece_color = Definitions.Colors.White
		"k":
			piece.type = Definitions.Pieces.King
			piece.piece_color = Definitions.Colors.Black
		"K":
			piece.type = Definitions.Pieces.King
			piece.piece_color = Definitions.Colors.White
		"q":
			piece.type = Definitions.Pieces.Queen
			piece.piece_color = Definitions.Colors.Black
		"Q":
			piece.type = Definitions.Pieces.Queen
			piece.piece_color = Definitions.Colors.White
		"r":
			piece.type = Definitions.Pieces.Rook
			piece.piece_color = Definitions.Colors.Black
		"R":
			piece.type = Definitions.Pieces.Rook
			piece.piece_color = Definitions.Colors.White
		"b":
			piece.type = Definitions.Pieces.Bishop
			piece.piece_color = Definitions.Colors.Black
		"B":
			piece.type = Definitions.Pieces.Bishop
			piece.piece_color = Definitions.Colors.White
		"n":
			piece.type = Definitions.Pieces.Knight
			piece.piece_color = Definitions.Colors.Black
		"N":
			piece.type = Definitions.Pieces.Knight
			piece.piece_color = Definitions.Colors.White
	return piece

# Return the piece name as a string for setting the piece texture.
func _get_piece_name(t) -> String:
	return ("black_" if piece_color else "white_") + Definitions.Pieces.find_key(t).to_lower()

# Change transparency of piece to show when mouse is hovered over.
func _on_mouse_entered() -> void:
	self_modulate = Color(1, 1, 1, 0.5)

# Change transparency of piece to show when mouse exits.
func _on_mouse_exited() -> void:
	self_modulate = Color(1, 1, 1, 1)

# Detect if piece was clicked on and emit piece clicked signal.
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		emit_signal("piece_clicked", self)
