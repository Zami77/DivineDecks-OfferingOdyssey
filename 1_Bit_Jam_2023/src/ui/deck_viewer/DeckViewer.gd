class_name DeckViewer
extends Node2D

signal close_deck_viewer

@onready var grid_container: GridContainer = $ScrollContainer/GridContainer
@onready var close_button: Button = $Panel/CloseButton

func _ready():
	z_index = ZIndexPosition.deck_viewer
	close_button.pressed.connect(_on_close_button_pressed)

func load_deck(deck: Array[Card.CardName]):
	for child in grid_container.get_children():
		child.queue_free()
	
	deck.sort()
	
	for card_name in deck:
		var control = Control.new()
		control.add_child(CardFactory.get_card_packed_scene(card_name))
		grid_container.add_child(control)
	
	# I have no idea why this needs to happen, 
	# but I have to add multiple empty controls to force scroll to occur
	for i in 3:
		grid_container.add_child(Control.new())

func _on_close_button_pressed() -> void:
	emit_signal("close_deck_viewer")
