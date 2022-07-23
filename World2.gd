extends Node2D


func _on_Area2D_area_entered(area):
	Global.goto_scene("res://World.tscn")
