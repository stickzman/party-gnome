class_name Potion
extends Resource

# Invariant: ingredients.length >= 2
@export var ingredients: Array[Ingredient]
@export var sprite: Texture2D

# Reduces all component buffs down to one large buff.
var effectBuff: Buff:
	get:
		var ingredientBuffs = self.ingredients.map(func(c): return c.effectBuff)
		var lotusBuff = Buff.lotusBuff(self.ingredients) # empty buff if no lotus
		return Buff.combineAll(ingredientBuffs).combine(lotusBuff)

# Must have at least two components to make the potion
func canMake() -> bool:
	return len(self.ingredients) >= 2
