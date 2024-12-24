class_name Collectable extends Node

static var items = []

static func addItem(item):
	items.push_back(item)
	
static func removeItem(idx:int):
	items.remove_at(idx)
