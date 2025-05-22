extends Node


var MC_Gameplay_KM: GUIDEMappingContext = preload("uid://lhaeaucdyjic")
var MC_Gameplay_CO: GUIDEMappingContext = preload("uid://cmc4c1fkaphya")

var MC_Cutscene: GUIDEMappingContext = preload("uid://benuypbhtm4kx")


var GlobalKM_MC: GUIDEMappingContext = preload("uid://lpid20wexkqi")
var GlobalC_MC: GUIDEMappingContext = preload("uid://cefjclary26h")

var SwitchToController: GUIDEAction = preload("uid://bodecev1qpdsm")
var SwitchToKeyboard: GUIDEAction = preload("uid://d34kig5piooos")


enum GameState {
	IN_GAME,
	CUTSCENE,
}
enum InputType {
	KEYBOARD,
	CONTROLLER
}

var game_state: GameState = GameState.IN_GAME
var input_type: InputType = InputType.KEYBOARD


func _update_input():
	match input_type:
		InputType.KEYBOARD:
			GUIDE.enable_mapping_context(GlobalKM_MC, true)
			match game_state:
				GameState.IN_GAME:
					GUIDE.enable_mapping_context(MC_Gameplay_KM)
				GameState.CUTSCENE:
					GUIDE.enable_mapping_context(MC_Cutscene)
		InputType.CONTROLLER:
			GUIDE.enable_mapping_context(GlobalC_MC, true)
			match game_state:
				GameState.IN_GAME:
					GUIDE.enable_mapping_context(MC_Gameplay_CO)
				GameState.CUTSCENE:
					GUIDE.enable_mapping_context(MC_Cutscene)

func _set_input_type(input: InputType):
	input_type = input
	_update_input()

func _set_game_state(state: GameState):
	game_state = state
	_update_input()

func _ready():
	SwitchToController.triggered.connect(_set_input_type.bind(InputType.CONTROLLER))
	SwitchToKeyboard.triggered.connect(_set_input_type.bind(InputType.KEYBOARD))

	_update_input()

func start_cutscene():
	_set_game_state(GameState.CUTSCENE)
func start_gameplay():
	_set_game_state(GameState.IN_GAME)
