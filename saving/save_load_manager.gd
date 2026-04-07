# User data should only be stored in the user:// path.
# While res:// can be used when running from the editor, when your project is exported,
# the res:// path becomes read-only.

extends Node

const save_path = "user://game.tres"

@export var score = 3

@export var stock_control: StockControl 
@export var quest_manager: QuestManager
	
func save_game(): 
	print("Saving game to file " + str(save_path))
	var save_data: SaveFileData = SaveFileData.new()
	
	var stock_save_data = stock_control.create_stock_save_data()
	save_data.stock_data = stock_save_data

	var quest_save_data = quest_manager.create_quest_save_data()
	save_data.quest_data = quest_save_data

	var error : Error = ResourceSaver.save(save_data, save_path)
	if error: 
		printerr("Attempt to save game to " + save_path + " yielded error " + str(error))
	else: 
		print("Save successful")
		
func load_game(): 
	if not FileAccess.file_exists(save_path):
		printerr("Load file not found at " + str(save_path))
		return
		
	print("Loading game from file " + str(save_path))
	if not ResourceLoader.exists(save_path, "SaveFileData"): 
		printerr("save file not found at: " + save_path)
		return
	
	var save_data: SaveFileData = ResourceLoader.load(save_path)
	print("Loaded save: " + str(save_data))
	stock_control.load_from_stock_save_data(save_data.stock_data)
	quest_manager.load_from_quest_save_data(save_data.quest_data)

func _on_save_button_pressed() -> void:
	save_game()
	
func _on_load_button_pressed() -> void:
	load_game()
