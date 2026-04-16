class_name PotionBelt
extends Node2D

enum Slot {FIRST, SECOND, NONE}
enum Selection {TOGGLED, SELECTED, NOTHING}

# At most two potions can be present
var firstPotion: Potion = null
var secondPotion: Potion = null

var selectedPotion = Slot.NONE

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
	var selection = toggleSelectPotion(PotionBelt.Slot.FIRST)
	if selection == PotionBelt.Selection.NOTHING:
		# nothing to select
		return ;
	if selection == PotionBelt.Selection.TOGGLED:
		$FirstPotionSlot/UsingPotionLabel.text = ""
		emit_signal("stop_using_potion", firstPotion)
		return
	if selection == PotionBelt.Selection.SELECTED:
		$FirstPotionSlot/UsingPotionLabel.text = USING_LABEL
		emit_signal("using_potion", firstPotion)

func on_use_second_potion():
	var selection = toggleSelectPotion(PotionBelt.Slot.SECOND)
	if selection == PotionBelt.Selection.NOTHING:
		# nothing to select
		return ;
	if selection == PotionBelt.Selection.TOGGLED:
		$SecondPotionSlot/UsingPotionLabel.text = ""
		emit_signal("stop_using_potion", secondPotion)
		return
	if selection == PotionBelt.Selection.SELECTED:
		$SecondPotionSlot/UsingPotionLabel.text = USING_LABEL
		emit_signal("using_potion", secondPotion)

func can_add_potion() -> bool:
	return !firstPotion or !secondPotion

# TODO: bug where adding a second potion overrides the first with the latest
func add_potion(potion: Potion):
	if !can_add_potion():
		# TODO: disable the make potion button somehow
		return
	addPotion(potion);
	# TODO: handle full?
	assert(firstPotion == potion or secondPotion == potion)
	assert(!(firstPotion == potion and secondPotion == potion))
	if firstPotion:
		$FirstPotionSlot/FirstPotionLabel.text = firstPotion.effectBuff.get_message();
		$FirstPotionSlot/UseFirstPotionButton.disabled = false
	else:
		$FirstPotionSlot/FirstPotionLabel.text = EMPTY_LABEL
		$FirstPotionSlot/UseFirstPotionButton.disabled = true
	
	if secondPotion:
		$SecondPotionSlot/SecondPotionLabel.text = secondPotion.effectBuff.get_message();
		$SecondPotionSlot/UseSecondPotionButton.disabled = false
	else:
		$SecondPotionSlot/SecondPotionLabel.text = EMPTY_LABEL
		$SecondPotionSlot/UseSecondPotionButton.disabled = true

func use_potion(potion: Potion):
	if firstPotion == potion:
		$FirstPotionSlot/FirstPotionLabel.text = EMPTY_LABEL
		$FirstPotionSlot/UseFirstPotionButton.disabled = true
		$FirstPotionSlot/UsingPotionLabel.text = ""
	else:
		# it better be the second potion or I'm gonna scream
		assert(secondPotion == potion)
		$SecondPotionSlot/SecondPotionLabel.text = EMPTY_LABEL
		$SecondPotionSlot/UseSecondPotionButton.disabled = true
		$SecondPotionSlot/UsingPotionLabel.text = ""
	removePotion(potion)


func toggleSelectPotion(slot: Slot) -> Selection:
	if (slot == Slot.FIRST and !firstPotion) or (slot == Slot.SECOND and !secondPotion):
		# Can't select what's not there
		return Selection.NOTHING
	if slot == selectedPotion:
		selectedPotion = Slot.NONE
		return Selection.TOGGLED;
	selectedPotion = slot
	return Selection.SELECTED # Only one selected at a time
	

func addPotion(potion: Potion) -> Slot:
	if self.firstPotion == null:
		self.firstPotion = potion
		return Slot.FIRST
		
	if self.secondPotion == null:
		self.secondPotion = potion
		return Slot.SECOND
		
	return Slot.NONE
	
func removePotion(potion: Potion) -> void:
	if firstPotion == potion:
		self.firstPotion = null
		return
		
	if secondPotion == potion:
		self.secondPotion = null
		return
