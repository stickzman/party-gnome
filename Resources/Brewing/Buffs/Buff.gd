class_name Buff
extends Resource

# Modifier is how much +/- to that particular action's value

# Regular effects from cherry, grape, and lemon
@export var attackValueModifier: int = 0
@export var defenseValueModifier: int = 0
@export var healthValueModifier: int = 0

# Special effects from Lotus
@export var attackMultModifier: int = 0
@export var hasImmunity: bool = false
@export var doesRevive: bool = false

# Combines two buffs together
func combine(buff: Buff) -> Buff:
	var newBuff = Buff.new()
	
	# Add values modifiers
	newBuff.attackValueModifier = self.attackValueModifier + buff.attackValueModifier
	newBuff.defenseValueModifier = self.defenseValueModifier + buff.defenseValueModifier
	newBuff.healthValueModifier = self.healthValueModifier + buff.healthValueModifier
	
	# Add attack mult modifier
	newBuff.attackMultModifier = self.attackMultModifier + buff.attackMultModifier
	
	# Any drop of these effects  makes the resulting buff have them
	newBuff.hasImmunity = self.hasImmunity or buff.hasImmunity
	newBuff.doesRevive = self.doesRevive or buff.doesRevive
	
	return newBuff

# Reduces all buffs down to a super-buff
static func combineAll(buffs: Array[Buff]) -> Buff:
	var combinedBuff: Buff = Buff.new()
	for b in buffs:
		combinedBuff.combine(b)
	return combinedBuff
	
	
# Special lotus buff, depends on other ingredients
static func lotusBuff(otherIngredients: Array[Ingredient]) -> Buff:
	var hasLemon = otherIngredients.any(func(i): i.name == "Lemon")
	var hasCherry = otherIngredients.any(func(i): i.name == "Cherry")
	var hasGrapes = otherIngredients.any(func(i): i.name == "Grapes")
	
	var lotusBuff = Buff.new()
	lotusBuff.doesRevive = hasLemon
	lotusBuff.hasImmunity = hasGrapes
	lotusBuff.attackMultModifier = int(hasCherry)
	return
