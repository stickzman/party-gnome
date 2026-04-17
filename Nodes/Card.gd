class_name Card
extends Control

signal selection_changed(is_selected: bool, _self: Card)

@export var ingredient: Ingredient
@export var is_selected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$InteractionButton.pressed.connect(pressed)
	$EffectLabel.text = ingredient.effectDescription
	$IngredientSprite.texture = ingredient.sprite
	self.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func pressed():
	self.is_selected = !self.is_selected
	if is_selected:
		$SelectionLabel.text = "Selected"
		$SelectionLabel.add_theme_color_override("font_color", Color.GREEN)
	else:
		$SelectionLabel.text = "Unselected"
		$SelectionLabel.add_theme_color_override("font_color", Color.WHITE)
		
	selection_changed.emit(self.is_selected, self)
