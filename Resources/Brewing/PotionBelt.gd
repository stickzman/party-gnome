class_name PotionBelt
extends Resource

# At most two potions can be present
@export var firstPotion: Potion = null
@export var secondPotion: Potion = null

func addPotion(potion: Potion) -> void:
	if firstPotion == null:
		self.firstPotion = potion
		return
		
	if secondPotion == null:
		self.secondPotion = potion
	
func removePotion(potion: Potion) -> void:
	if firstPotion == potion:
		self.firstPotion = null
		return
		
	if secondPotion == potion:
		self.secondPotion = null
		return
