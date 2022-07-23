extends Control


# ---------------
# Health UI admin
# ---------------
var hearts = 5 setget setHearts
var maxHearts = 5 setget setMaxHearts

# Full hearts UI element
onready var heartUIFull = $HeartUIFull
# Empty hearts UI element
onready var heartUIEmpty = $HeartUIEmpty


# ---------------
# Health UI funcs
# ---------------

func setHearts(value):
	hearts = clamp(value, 0, maxHearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 15

func setMaxHearts(value):
	maxHearts = max(value, 1)
	self.hearts = min(hearts, maxHearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = maxHearts * 15



# ----------
# Init stuff
# ----------

func _ready():
	# ---------
	# Health UI
	# ---------
	self.maxHearts = PlayerStats.maxHealth
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "setHearts")
	PlayerStats.connect("max_health_changed", self, "setMaxHearts")
