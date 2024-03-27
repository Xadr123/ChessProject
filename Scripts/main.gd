extends Node

var board_ui =  BoardUI.new()
var selected_piece = null
var turn = Definitions.Colors.White
var player = Definitions.Colors.White

func _ready() -> void:
	add_child(board_ui)
	create_board_ui()

func _on_test_button_pressed() -> void:
	set_pieces()

# Create board with squares based on rank and file.
func create_board_ui() -> void:
	var square
	for rank in range(Definitions.Ranks.size()):
		for file in range(Definitions.Files.size()):
			square = Square.new(rank, file)
			square.square_clicked.connect(_on_square_clicked)
			board_ui.add_child(square)

# Create pieces based on starting FEN string.
func set_pieces() -> void:
	var index = 0
	# var fen = "rnbqkbnr/pp1pp1pp/8/1Pp5/5pP1/8/P1PPPP1P/RNBQKBNR w KQkq - 0 1".split(" ")
	var fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR".split(" ")
	for i in fen[0]:
		if i == "/": continue
		if i.is_valid_int():
			index += i.to_int()
		else:
			var piece = Piece.create_from_fen(i)
			create_piece(piece, index)
			index += 1

# Create piece with all properties and connect signals.
func create_piece(p, i) -> void:
	var piece = p
	piece.square_id = i
	piece.global_position = board_ui.get_children()[i].global_position
	piece.mouse_entered.connect(piece._on_mouse_entered)
	piece.mouse_exited.connect(piece._on_mouse_exited)
	piece.gui_input.connect(piece._on_gui_input)
	piece.piece_clicked.connect(_on_piece_clicked)
	board_ui.get_child(i).square_occupied = true
	board_ui.get_child(i).piece = piece
	add_child(piece)

func _on_piece_clicked(clicked_piece) -> void:
	print(clicked_piece.square_id)
	if selected_piece == null:
		selected_piece = clicked_piece
		print("Selected Piece: " + Definitions.Colors.find_key(selected_piece.piece_color) + " " + Definitions.Pieces.find_key(selected_piece.type))
	elif clicked_piece == selected_piece:
		selected_piece = null
		print("Deselected Piece: " + Definitions.Colors.find_key(clicked_piece.piece_color) + " " + Definitions.Pieces.find_key(clicked_piece.type))
	else:
		_on_square_clicked(board_ui.get_child(clicked_piece.square_id))

func _on_square_clicked(clicked_square) -> void:
	if selected_piece == null:
		print(clicked_square.name + " clicked.")
		return
	else:
		move_piece(selected_piece, clicked_square)

func move_piece(piece, destination_square) -> void:

	# if piece.piece_color != turn:
	# 	return

	var start_file = board_ui.get_child(piece.square_id).file
	var start_rank = board_ui.get_child(piece.square_id).rank
	var end_file = board_ui.get_child(destination_square.id).file
	var end_rank = board_ui.get_child(destination_square.id).rank

	var move_vector = Vector3(start_rank - end_rank, start_file - end_file, abs(start_rank - end_rank) + abs(start_file - end_file))
	var move = Move.new(start_file, start_rank, end_file, end_rank)

	var move_result = move.is_valid_move(piece, board_ui.get_children(), destination_square.id, move_vector, turn, player)

	print(move_vector)

	if move_result.valid_move == false:
		return
	else:
		print(move_result.piece_to_remove)
		if move_result.piece_to_remove != null:
			print(move_result.piece_to_remove)
			move_result.piece_to_remove.queue_free()
		if move_vector.x == 1 and move_vector.y == 1:
			pass
		board_ui.get_child(piece.square_id).piece = 0
		board_ui.get_child(piece.square_id).square_occupied = false
		piece.square_id = destination_square.id
		piece.move_count += 1
		destination_square.piece = piece
		destination_square.square_occupied = true
		piece.global_position = destination_square.global_position
		print(Definitions.Colors.find_key(piece.piece_color) + " " + Definitions.Pieces.find_key(piece.type) + " moving to: " + destination_square.name)
		selected_piece = null
		if turn == Definitions.Colors.White:
			turn = Definitions.Colors.Black
		else:
			turn = Definitions.Colors.White
