class_name Potion
extends Resource

# Invariant: ingredients.length >= 2
@export var ingredients: Array[Ingredient] = []

# Reduces all component buffs down to one large buff.
var effectBuff: Buff:
	get:
		var lotusBuff = Buff.lotusBuff(self.ingredients) # empty buff if no lotus
		for ingredient in ingredients:
			print("Ingredient", ingredient)
			print("buff combined", ingredient.effectBuff)
			print("buff message", ingredient.effectBuff.get_message())
			lotusBuff = lotusBuff.combine(ingredient.effectBuff)
		return lotusBuff
		
# Must have at least two components to make the potion
func canMake() -> bool:
	return len(self.ingredients) >= 2
