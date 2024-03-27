extends Node
class_name Move

var start_rank = 0
var start_file = 0
var end_rank = 0
var end_file = 0
var distance_moved = 0

func _init(s_file, s_rank, e_file, e_rank) -> void:
	start_file = s_file
	start_rank = s_rank
	end_file = e_file
	end_rank = e_rank

func is_valid_move(piece, board, location, v, turn, player):
	match piece.type:
		Definitions.Pieces.Pawn:
			return Validator.validate_pawn(piece, board, location, v, turn, player)
		Definitions.Pieces.Knight:
			return Validator.validate_knight(piece, board, location, v, turn, player)
		Definitions.Pieces.Rook:
			return Validator.validate_rook(piece, board, location, v, turn, player)
		Definitions.Pieces.Bishop:
			return Validator.validate_bishop(piece, board, location, v, turn, player)
		Definitions.Pieces.Queen:
			return Validator.validate_queen(piece, board, location, v, turn, player)
		Definitions.Pieces.King:
			return Validator.validate_king(piece, board, location, v, turn, player)
	return false
