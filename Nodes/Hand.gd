extends Node2D

@export var potentialPotion: Potion = Potion.new()
var selectedIngredients: Array[Ingredient] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MakePotionButton.disabled = true
	# Gather ingredients from cards
	var cards = get_tree().get_nodes_in_group("card")
	for c in cards:
		c.connect("ingredient_selection_changed", on_ingredient_selection_changed)

func update_potential_potion():
	self.potentialPotion.ingredients = self.selectedIngredients
	var message = self.potentialPotion.effectBuff.get_message()
	%PotentialPotionStatusLabel.text = message
	
func update_can_make_button():
	$MakePotionButton.disabled = !potentialPotion.canMake()

func on_ingredient_selection_changed(is_selected: bool, ingredient: Ingredient):
	if is_selected:
		selectedIngredients.append(ingredient)
	else:
		var i = selectedIngredients.find(ingredient)
		assert(i != -1, "We should keep track of all ingredients")
		selectedIngredients.remove_at(i)	
	
	update_potential_potion();
	update_can_make_button();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
