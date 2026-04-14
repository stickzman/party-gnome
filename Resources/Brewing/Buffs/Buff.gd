class_name Buff
extends Resource

const INITIAL_ATTACK_VALUE_MODIFIER = 0
const INITIAL_DEFENSE_VALUE_MODIFIER = 0
const INITIAL_HEALTH_VALUE_MODIFIER = 0

const INITIAL_ATTACK_MULT_MODIFIER = 0

const INITIAL_HAS_IMMUNITY = false
const INITIAL_DOES_REVIVE = false

# Modifier is how much +/- to that particular action's value

# Regular effects from cherry, grape, and lemon
@export var attackValueModifier: int = INITIAL_ATTACK_VALUE_MODIFIER
@export var defenseValueModifier: int = INITIAL_DEFENSE_VALUE_MODIFIER
@export var healthValueModifier: int = INITIAL_HEALTH_VALUE_MODIFIER

# Special effects from Lotus
@export var attackMultModifier: int = INITIAL_ATTACK_MULT_MODIFIER
@export var hasImmunity: bool = INITIAL_HAS_IMMUNITY
@export var doesRevive: bool = INITIAL_DOES_REVIVE

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
	
func get_message() -> String:
	var message: Array[String] = []
	if attackValueModifier != INITIAL_ATTACK_VALUE_MODIFIER:
		message.append("%+d ATK" % [attackValueModifier])
	if defenseValueModifier != INITIAL_DEFENSE_VALUE_MODIFIER:
		message.append("%+d DEF" % [defenseValueModifier])
	if healthValueModifier != INITIAL_HEALTH_VALUE_MODIFIER:
		message.append("%+d HP" % [healthValueModifier])
		
	if attackMultModifier != INITIAL_ATTACK_MULT_MODIFIER:
		message.append("%+d ATK MULT" % [attackMultModifier])
	
	if hasImmunity != INITIAL_HAS_IMMUNITY:
		message.append("Has immunity from damage this turn.")
		
	if doesRevive != INITIAL_DOES_REVIVE:
		message.append("Revives a dead NPC.")
		
	return ". ".join(message)
		

# Reduces all buffs down to a super-buff
static func combineAll(buffs: Array[Buff]) -> Buff:
	var combinedBuff: Buff = Buff.new()
	for b in buffs:
		combinedBuff.combine(b)
	return combinedBuff
	
	
# Special lotus buff, depends on other ingredients
static func getLotusBuff(otherIngredients: Array[Ingredient]) -> Buff:
	var lotusBuff = Buff.new()
	# If not holding a lotus, return an empty buff
	if !otherIngredients.any(func(i): return i.name == "Lotus"): return lotusBuff

	var hasLemon = otherIngredients.any(func(i): return i.name == "Lemon")
	var hasCherry = otherIngredients.any(func(i): return i.name == "Cherry")
	var hasGrapes = otherIngredients.any(func(i): return i.name == "Grapes")
	
	lotusBuff.doesRevive = hasLemon
	lotusBuff.hasImmunity = hasGrapes
	lotusBuff.attackMultModifier = int(hasCherry)
	return lotusBuff
