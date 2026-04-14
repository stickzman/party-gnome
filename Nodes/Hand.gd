extends Node2D

signal potion_created

var potentialPotion: Potion = Potion.new()
var selectedCards: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MakePotionButton.disabled = true
	$MakePotionButton.connect("pressed", on_potion_make_button_pressed)
	# Gather ingredients from cards
	var cards = get_tree().get_nodes_in_group("card")
	for c in cards:
		c.connect("selection_changed", on_ingredient_selection_changed)

func update_potential_potion():
	self.potentialPotion.ingredients = []
	for c in selectedCards:
		self.potentialPotion.ingredients.append(c.ingredient)
		
	var message = self.potentialPotion.effectBuff.get_message()
	%PotentialPotionStatusLabel.text = message
	
func update_can_make_button():
	$MakePotionButton.disabled = !potentialPotion.canMake()

func on_ingredient_selection_changed(is_selected: bool, card: Node2D):
	if is_selected:
		selectedCards.append(card)
	else:
		var i = selectedCards.find(card)
		assert(i != -1, "We should keep track of all cards")
		selectedCards.remove_at(i)
	
	update_potential_potion();
	update_can_make_button();

func on_potion_make_button_pressed():
	print("make potion pressed")
	assert(potentialPotion.canMake(), ">=2 ingredients in potion")
	potion_created.emit(potentialPotion)
	potentialPotion = Potion.new() # reset potion
	
	# Remove ingredient cards as used
	for c in selectedCards:
		c.hide();
		# TODO: keep track of card location in the card?
		# TODO: resource leak?
		# These need to go to the "exiled" pile
		# After the potion gets used, they should
		# transition back to the "discard" pile
	
	self.selectedCards = [];
	
	# Reset potential potion
	update_potential_potion();
