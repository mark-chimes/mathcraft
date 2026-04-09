extends Node2D

@export var quest_name_label : Label
@export var quest_description_label : RichTextLabel

func _on_update_quest_text(quest: QuestDetails): 
	quest_name_label.text = quest.quest_title
	
	quest_description_label.clear()
	
	quest_description_label.append_text(quest.quest_description)
	quest_description_label.newline()
	quest_description_label.newline()
		
	for specifier in quest.yield_specifiers:
		var yield_description = specifier.description()
		quest_description_label.append_text(yield_description)
		quest_description_label.newline()
 
	var items_needed = []
	var items_produced = []
	var item_mods = quest.item_mods
	
	for item in item_mods: 
		var qty = item_mods[item]
		var item_name = item.display_name
		if qty > 0:
			items_produced.append(item_name + ": +" + str(qty))
		elif qty < 0: 
			items_needed.append(item_name + ": " + str(qty))

	if len(items_needed) > 0: 
		for item_str in items_needed: 
			quest_description_label.append_text(item_str)
			quest_description_label.newline()
	if len(items_produced) > 0: 
		for item_str in items_produced: 
			quest_description_label.append_text(item_str)
			quest_description_label.newline()
