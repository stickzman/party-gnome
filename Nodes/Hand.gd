class_name Hand
extends Control

signal potion_created

@export var potentialPotion: Potion = Potion.new()
var selectedCards: Array[Card] = []

@onready var cardSlots = $CardSlots

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MakePotionButton.disabled = true
	$MakePotionButton.connect("pressed", on_potion_make_button_pressed)
	# Gather ingredients from cards
	var cards = get_tree().get_nodes_in_group("card")
	for c in cards:
		c.connect("selection_changed", on_ingredient_selection_changed)

const CARD_SCENE = preload("res://Nodes/Card.tscn")

func grab(ingredients: Array[Ingredient]):
	for ingredient in ingredients:
		var card: Card = CARD_SCENE.instantiate();
		card.ingredient = ingredient
		card.selection_changed.connect(on_ingredient_selection_changed)
		cardSlots.add_child(card)
	

func update_potential_potion():
	self.potentialPotion.ingredients = []
	for c in selectedCards:
		self.potentialPotion.ingredients.append(c.ingredient)
		
	var message = self.potentialPotion.effectBuff.get_message()
	%PotentialPotionStatusLabel.text = message
	
func update_can_make_button():
	$MakePotionButton.disabled = !potentialPotion.canMake()

func on_ingredient_selection_changed(is_selected: bool, card: Card):
	if is_selected:
		selectedCards.append(card)
		assert(!selectedCards.is_empty(), "we have to add to the selected cards")
	else:
		var i = selectedCards.find(card)
		assert(i != -1, "We should keep track of all cards")
		selectedCards.remove_at(i)
		
	
	update_potential_potion();
	update_can_make_button();
	
func discard_remaining() -> Array[Ingredient]:
	var ingredients_to_discard: Array[Ingredient] = []
	for card in cardSlots.get_children():
		assert(card is Card, "only cards in the card slots")
		ingredients_to_discard.append(card.ingredient)
		card.queue_free()

	selectedCards = []
	return ingredients_to_discard

func on_potion_make_button_pressed():
	assert(potentialPotion.canMake(), ">=2 ingredients in potion")
	potion_created.emit(potentialPotion)
	potentialPotion = Potion.new() # reset potion
	
	# Remove ingredient cards as used
	for card in selectedCards:
		card.queue_free()
	
	self.selectedCards = [];
	
	# Reset potential potion
	update_potential_potion();
	update_can_make_button();
