extends Node2D

func _on_Area2D_area_entered(_area):
	Global.goto_scene("res://World2.tscn")
