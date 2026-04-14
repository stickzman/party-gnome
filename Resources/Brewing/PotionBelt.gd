class_name PotionBelt
extends Resource

enum Slot {FIRST, SECOND, NONE}
enum Selection {TOGGLED, SELECTED, NOTHING}

# At most two potions can be present
@export var firstPotion: Potion = null
@export var secondPotion: Potion = null

@export var selectedPotion = Slot.NONE

func toggleSelectPotion(slot: Slot) -> Selection:
	if (slot == Slot.FIRST and !firstPotion) or (slot == Slot.SECOND and !secondPotion):
		# Can't select what's not there
		return Selection.NOTHING
	if slot == selectedPotion:
		selectedPotion = Slot.NONE
		return Selection.TOGGLED;
	selectedPotion = slot
	return Selection.SELECTED # Only one selected at a time
	

func addPotion(potion: Potion) -> Slot:
	if self.firstPotion == null:
		self.firstPotion = potion
		return Slot.FIRST
		
	if self.secondPotion == null:
		self.secondPotion = potion
		return Slot.SECOND
		
	return Slot.NONE
	
func removePotion(potion: Potion) -> void:
	if firstPotion == potion:
		self.firstPotion = null
		return
		
	if secondPotion == potion:
		self.secondPotion = null
		return
