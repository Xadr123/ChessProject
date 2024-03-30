extends Node
class_name Validator

static func validate_pawn(piece, board, location, v, turn, player) -> Move_Result:
	var piece_rank = board[piece.square_id].rank
	var piece_file = board[piece.square_id].file
	var destination_square = board[location]
	var destination_rank = destination_square.rank
	var destination_file = destination_square.file
	var neighbor_square = board[piece.square_id + (destination_file - piece_file)]

	#move_side is -1 for black moves, +1 for white moves
	var move_side = -1
	if turn == Definitions.Colors.White:
		move_side = 1

	#pawns can only move 1 or 2 spaces
	if v.z > 2:
		return Move_Result.new(false, null)

	var square_id_delta = destination_square.id - piece.square_id

	#pawns cannot move backwards 
	if (square_id_delta < 0 && piece.piece_color != player):
		return Move_Result.new(false, null)
	elif (square_id_delta > 0 && piece.piece_color == player):
		return Move_Result.new(false, null)

	#pawns cannot move left and right
	if abs(v.y) > 0 and abs(v.x) == 0:
		return Move_Result.new(false, null)

	#attempting to move diagonally (capture)
	if(abs(v.x) == 1 && abs(v.y) == 1):
		if (piece_rank == 4 or piece_rank == 5):
			#dest square should be empty
			#neighbor should *not* be empty
			#neighbor should have moved only once
			if destination_square.square_occupied == false && neighbor_square.square_occupied:
				if neighbor_square.piece.move_count == 1 && neighbor_square.piece.type == Definitions.Pieces.Pawn:
					print("en passant")
					return Move_Result.new(true, neighbor_square.piece)

		#dest is not empty
		#dest piece is not same colour
		if destination_square.square_occupied && destination_square.piece.piece_color != piece.piece_color:
			return Move_Result.new(true, destination_square.piece)

		return Move_Result.new(false, null)
	#moving forward without capturing
	else:
		#pawn can only move 1 space after it's first move
		if v.z > 1 and piece.move_count != 0:
			return Move_Result.new(false, null)
		#pawns cannot jump over pieces
		for i in v.z:
			if board[location + (i * 8 * move_side)].square_occupied == true:
				return Move_Result.new(false, board[piece.square_id])
	
	return Move_Result.new(true, null)

static func validate_knight(piece, board, location, v, turn, player) -> Move_Result:
	var destination_square = board[location]

	#horesy moves in funny shape
	if !(abs(v.x) == 2 && abs(v.y) == 1) && !(abs(v.x) == 1 && abs(v.y) == 2):
		return Move_Result.new(false, null)

	#handle captures
	if destination_square.square_occupied && destination_square.piece.piece_color != piece.piece_color:
		return Move_Result.new(true, destination_square.piece)
	#piece cannot go to occupied friendly square
	elif destination_square.square_occupied && destination_square.piece.piece_color == piece.piece_color:
		return Move_Result.new(false, null)

	return Move_Result.new(true, null)

static func validate_rook(piece, board, location, v, turn, player) -> Move_Result:
	var destination_square = board[location]
	var movement_direction = 1
	if (destination_square.id - piece.square_id) < 0:
		movement_direction = -1

	# rook can only move linearly
	if (v.x != 0 && v.y != 0):
		return Move_Result.new(false, null)

	# cannot move through other pieces
	if abs(v.y) - 1 > 0:
		print('y > 0')
		for i in abs(v.y) - 1:
			print(str("i ", i))
			if board[piece.square_id + ((i + 1) * movement_direction)].square_occupied:
				print(str(board[piece.square_id + ((i + 1) * movement_direction)], " is occupied"))
				return Move_Result.new(false, null)
	else:
		print('x > 0')
		for i in abs(v.x) - 1:
			print(str("i ", i))
			if board[piece.square_id + (8 * (i + 1) * movement_direction)].square_occupied:
				print(str(board[piece.square_id + ((i + 1) * movement_direction)], " is occupied"))
				return Move_Result.new(false, null)

	#captures
	if destination_square.square_occupied:
		print('dest is capture')
		if destination_square.piece.piece_color != piece.piece_color:
			print('dest is different colour')
			return Move_Result.new(true, destination_square.piece)
		print('dest is same color')
		return Move_Result.new(false, null)


	return Move_Result.new(true, null)

static func validate_bishop(piece, board, location, v, turn, player) -> Move_Result:
	var destination_square = board[location]
	var piece_rank = board[piece.square_id].rank
	var piece_file = board[piece.square_id].file
	var destination_rank = destination_square.rank
	var destination_file = destination_square.file
	var file_delta = destination_file - piece_file
	var rank_delta = destination_rank - piece_rank
	var file_modifier = 1
	var rank_modifier = -1

	if file_delta < 0:
		file_modifier = -1
	
	if rank_delta < 0:
		rank_modifier = 1

	# must move diagonally in equal proportions
	if abs(v.x) != abs(v.y):
		return Move_Result.new(false, null)

	print(str("fm ", file_modifier, " rm ", rank_modifier));

	#cannot move through other pieces
	if abs(v.x) - 1 > 0:
		for i in abs(v.x) - 1:
			print(str(((i + 1) * 8 * rank_modifier) + ((i + 1) * file_modifier)));
			if board[piece.square_id + (((i + 1) * 8 * rank_modifier) + ((i + 1) * file_modifier))].square_occupied:
				return Move_Result.new(false, null)
	
	#captures
	if destination_square.square_occupied:
		print('dest is capture')
		if destination_square.piece.piece_color != piece.piece_color:
			print('dest is different colour')
			return Move_Result.new(true, destination_square.piece)
		print('dest is same color')
		return Move_Result.new(false, null)

	return Move_Result.new(true, null)

static func validate_queen(piece, board, location, v, turn, player) -> Move_Result:
	var destination_square = board[location]
	var movement_direction = 1
	var piece_rank = board[piece.square_id].rank
	var piece_file = board[piece.square_id].file
	var destination_rank = destination_square.rank
	var destination_file = destination_square.file
	var file_delta = destination_file - piece_file
	var rank_delta = destination_rank - piece_rank
	var file_modifier = 1
	var rank_modifier = -1

	if file_delta < 0:
		file_modifier = -1
	elif file_delta == 0:
		file_modifier = 0
	
	if rank_delta < 0:
		rank_modifier = 1
	elif rank_delta == 0:
		rank_modifier = 0
	
	if (destination_square.id - piece.square_id) < 0:
		movement_direction = -1
	
	# cannot move through other pieces
	if (abs(v.x) == abs(v.y)):
		# moving diagon alley
		if abs(v.x) - 1 > 0:
			for i in abs(v.x) - 1:
				print(str(((i + 1) * 8 * rank_modifier) + ((i + 1) * file_modifier)));
				if board[piece.square_id + (((i + 1) * 8 * rank_modifier) + ((i + 1) * file_modifier))].square_occupied:
					return Move_Result.new(false, null)
	elif v.x == 0 || v.y == 0:
		# moving linearly
		if abs(v.y) - 1 > 0:
			print('y > 0')
			for i in abs(v.y) - 1:
				print(str("i ", i))
				if board[piece.square_id + ((i + 1) * movement_direction)].square_occupied:
					print(str(board[piece.square_id + ((i + 1) * movement_direction)], " is occupied"))
					return Move_Result.new(false, null)
		else:
			print('x > 0')
			for i in abs(v.x) - 1:
				print(str("i ", i))
				if board[piece.square_id + (8 * (i + 1) * movement_direction)].square_occupied:
					print(str(board[piece.square_id + ((i + 1) * movement_direction)], " is occupied"))
					return Move_Result.new(false, null)
	else:
		# queen no is horsey
		return Move_Result.new(false, null)
		
	# captures
	if destination_square.square_occupied:
		print('dest is capture')
		if destination_square.piece.piece_color != piece.piece_color:
			print('dest is different colour')
			return Move_Result.new(true, destination_square.piece)
		print('dest is same color')
		return Move_Result.new(false, null)

	return Move_Result.new(true, null)

static func validate_king(piece, board, location, v, turn, player) -> Move_Result:
	var destination_square = board[location]

	# castle rights
	# can castle left/right side if rook and king have not moved, and there are NO pieces in between
	# king cannot be in check
	# king does not land on or pass through a square under attack

	# function for king in check (should go in main?)
	# check surrounding squares for friendly pieces
	# if a rank/file does not have a friendly piece in front, check for enemy piece
	# if enemy piece can move more than 1 square, and can move to king, check
	# if enemy piece can check, king must move out of check
	# if no moves result in no check, check mate

	# king can only move 1 square in any direction
	if abs(v.x) > 1 || abs(v.y) > 1:
		return Move_Result.new(false, null)
		
	#captures
	if destination_square.square_occupied:
		print('dest is capture')
		if destination_square.piece.piece_color != piece.piece_color:
			print('dest is different colour')
			return Move_Result.new(true, destination_square.piece)
		print('dest is same color')
		return Move_Result.new(false, null)

	return Move_Result.new(true, null)

class Move_Result:
	var valid_move : bool
	var piece_to_remove
	
	func _init(v_move, p_move) -> void:
		valid_move = v_move
		piece_to_remove = p_move
