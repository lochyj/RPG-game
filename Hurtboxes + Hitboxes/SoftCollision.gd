extends Area2D

func isColliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func getPushVector():
	var areas = get_overlapping_areas()
	var pushVectors = Vector2.ZERO
	if isColliding():
		var area = areas[0]
		pushVectors = area.global_position.direction_to(global_position)
		pushVectors = pushVectors.normalized()
	return pushVectors

