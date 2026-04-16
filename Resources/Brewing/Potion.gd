class_name Potion
extends Resource

# Invariant: ingredients.length >= 2
@export var ingredients: Array[Ingredient] = []
@export var sprite: Texture2D

# Reduces all component buffs down to one large buff.
var effectBuff: Buff:
	get:
		var lotusBuff = Buff.getLotusBuff(self.ingredients) # empty buff if no lotus
		for ingredient in ingredients:
			if ingredient.effectBuff == null: continue
			lotusBuff = lotusBuff.combine(ingredient.effectBuff)
		return lotusBuff

# Must have at least two components to make the potion
func canMake() -> bool:
	return len(self.ingredients) >= 2
