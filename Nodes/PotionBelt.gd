extends Node2D

var potionBelt: PotionBelt = PotionBelt.new()

const EMPTY_LABEL = "(empty)"
const USING_LABEL = "Using"

signal using_potion
signal stop_using_potion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FirstPotionSlot/UseFirstPotionButton.connect("pressed", on_use_first_potion)
	$SecondPotionSlot/UseSecondPotionButton.connect("pressed", on_use_second_potion)
	$FirstPotionSlot/UsingPotionLabel.text = ""
	$SecondPotionSlot/UsingPotionLabel.text = ""

func on_use_first_potion():
	var selection = potionBelt.toggleSelectPotion(PotionBelt.Slot.FIRST)
	if selection == PotionBelt.Selection.NOTHING:
		# nothing to select
		return ;
	if selection == PotionBelt.Selection.TOGGLED:
		$FirstPotionSlot/UsingPotionLabel.text = ""
		emit_signal("stop_using_potion", potionBelt.firstPotion)
		return
	if selection == PotionBelt.Selection.SELECTED:
		$FirstPotionSlot/UsingPotionLabel.text = USING_LABEL
		emit_signal("using_potion", potionBelt.firstPotion)

func on_use_second_potion():
	var selection = potionBelt.toggleSelectPotion(PotionBelt.Slot.SECOND)
	if selection == PotionBelt.Selection.NOTHING:
		# nothing to select
		return ;
	if selection == PotionBelt.Selection.TOGGLED:
		$SecondPotionSlot/UsingPotionLabel.text = ""
		emit_signal("stop_using_potion", potionBelt.secondPotion)
		return
	if selection == PotionBelt.Selection.SELECTED:
		$SecondPotionSlot/UsingPotionLabel.text = USING_LABEL
		emit_signal("using_potion", potionBelt.secondPotion)
	
# TODO: bug where adding a second potion overrides the first with the latest
func add_potion(potion: Potion):
	potionBelt.addPotion(potion);
	assert(potionBelt.firstPotion == potion or potionBelt.secondPotion == potion)
	assert(!(potionBelt.firstPotion == potion and potionBelt.secondPotion == potion))
	if potionBelt.firstPotion:
		$FirstPotionSlot/FirstPotionLabel.text = potionBelt.firstPotion.effectBuff.get_message();
		$FirstPotionSlot/UseFirstPotionButton.disabled = false
	else:
		$FirstPotionSlot/FirstPotionLabel.text = EMPTY_LABEL
		$FirstPotionSlot/UseFirstPotionButton.disabled = true
	
	if potionBelt.secondPotion:
		$SecondPotionSlot/SecondPotionLabel.text = potionBelt.secondPotion.effectBuff.get_message();
		$SecondPotionSlot/UseSecondPotionButton.disabled = false
	else:
		$SecondPotionSlot/SecondPotionLabel.text = EMPTY_LABEL
		$SecondPotionSlot/UseSecondPotionButton.disabled = true

# TODO: to be called by game manager or whatever manage selecting characters
func use_potion(potion: Potion):
	if potionBelt.firstPotion == potion:
		$FirstPotionSlot/FirstPotionLabel.text = EMPTY_LABEL
		$FirstPotionSlot/UseFirstPotionButton.disabled = true
	else:
		# it better be the second potion or I'm gonna scream
		assert(potionBelt.secondPotion == potion)
		$SecondPotionSlot/SecondPotionLabel.text = EMPTY_LABEL
		$SecondPotionSlot/UseSecondPotionButton.disabled = true
