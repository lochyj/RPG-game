extends Node2D

# -------------------------------------------------------------------------------------
# Preloading the scene saves loading the scene every time the grass effect is instanced
# -------------------------------------------------------------------------------------
const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()
