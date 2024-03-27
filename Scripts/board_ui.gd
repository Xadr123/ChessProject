extends GridContainer
class_name BoardUI

# Initialize grid container sizing and seperation, and create the board.
func _init() -> void:
	name = "BoardUI"
	custom_minimum_size = Definitions.SQUARE_SIZE * 8
	columns = 8
	add_theme_constant_override("h_separation", 0)
	add_theme_constant_override("v_separation", 0)
