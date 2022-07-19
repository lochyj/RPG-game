extends AnimatedSprite

func _ready():
	self.connect("animation_finished", self, "animationFinished")
	frame = 0
	play("Animate")

func animationFinished():
	queue_free()
