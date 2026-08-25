extends Node
class_name Interactable

signal on_interact

func interact():
	print("Woah you interacted with me, hot dang")
	on_interact.emit()
