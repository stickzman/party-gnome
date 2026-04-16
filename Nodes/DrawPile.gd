class_name DrawPile
extends Node2D

# card pile
@export var pile: Array[Ingredient] = [
	preload("res://Resources/Brewing/Ingredients/Cherry.tres"),
	preload("res://Resources/Brewing/Ingredients/Cherry.tres"),
	preload("res://Resources/Brewing/Ingredients/Cherry.tres"),
	
	preload("res://Resources/Brewing/Ingredients/Grape.tres"),
	preload("res://Resources/Brewing/Ingredients/Grape.tres"),
	preload("res://Resources/Brewing/Ingredients/Grape.tres"),
	
	preload("res://Resources/Brewing/Ingredients/Lemon.tres"),
	preload("res://Resources/Brewing/Ingredients/Lemon.tres"),
	preload("res://Resources/Brewing/Ingredients/Lemon.tres"),
	
	preload("res://Resources/Brewing/Ingredients/Lotus.tres")
]
@onready var count_label = $CardCountLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pile.shuffle();
	pass # Replace with function body.
	
func draw_card() -> Ingredient:
	return pile.pop_back()

# Draws at most n cards, or pile.size()
func try_draw_n(n: int) -> Array[Ingredient]:
	var drawn: Array[Ingredient] = []
	for _i in range(0, n):
		if pile.is_empty():
			return drawn
		drawn.append(pile.pop_back())
	return drawn
	
func is_empty():
	return pile.is_empty()

func shuffle_in(ingredients: Array[Ingredient]):
	pile = ingredients
	pile.shuffle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	count_label.text = str(pile.size())
