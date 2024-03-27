extends Node
class_name Definitions

# Constants for board and squares
const BOARD_SQUARE_COUNT = 64
const SQUARE_SIZE = Vector2(64, 64)
const LIGHT_COLOR = Color.ANTIQUE_WHITE
const DARK_COLOR = Color.FOREST_GREEN

# Enums for rank, file, pieces, and colors.
enum Ranks { RANK_1, RANK_2, RANK_3, RANK_4, RANK_5, RANK_6, RANK_7, RANK_8 }
enum Files { FILE_A, FILE_B, FILE_C, FILE_D, FILE_E, FILE_F, FILE_G, FILE_H }
enum Colors { White, Black }
enum Pieces { None, King, Pawn, Knight, Bishop, Rook, Queen }
enum Squares {
	A8, B8, C8, D8, E8, F8, G8, H8,
	A7, B7, C7, D7, E7, F7, G7, H7,
	A6, B6, C6, D6, E6, F6, G6, H6,
	A5, B5, C5, D5, E5, F5, G5, H5,
	A4, B4, C4, D4, E4, F4, G4, H4,
	A3, B3, C3, D3, E3, F3, G3, H3,
	A2, B2, C2, D2, E2, F2, G2, H2,
	A1, B1, C1, D1, E1, F1, G1, H1
	}
