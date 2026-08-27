extends Node3D
class_name Inventory

signal inventory_changed(items: Array[ContrabandItem])

var carrying : Array[ContrabandItem]
var has_heavy_item := false

func _ready():
	inventory_changed.emit(carrying)

func add_item(item: ContrabandItem) -> bool:
	if has_heavy_item: return false
	carrying.append(item)
	has_heavy_item = carrying.any(func(item: ContrabandItem): return item.heavy)
	inventory_changed.emit(carrying)
	return true

func empty_inventory():
	carrying.clear()
	inventory_changed.emit(carrying)
