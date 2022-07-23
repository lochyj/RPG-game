extends Node2D

export var path = "res://World2.tscn"

func _on_Area2D_area_entered(_area):
	Global.goto_scene(path)
