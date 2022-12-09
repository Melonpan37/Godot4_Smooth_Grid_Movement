extends AnimatedSprite2D

enum {UP, RIGHT, DOWN, LEFT}
const DIR2VEC = [
	Vector2.UP,
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT
]
const DIR2STR = [
	"up",
	"right",
	"down",
	"left"
]
const MOVE_INPUT_MAP = [
	"ui_up",
	"ui_right",
	"ui_down",
	"ui_left"
]


const MOTION_DISTANCE : int = 16
const MOTION_DURATION : float = 0.15

enum {IDLE, WALK}
var state = IDLE
var direction : int = DOWN

func get_movement_input() -> int :
	for i in range(MOVE_INPUT_MAP.size()) :
		if Input.is_action_pressed(MOVE_INPUT_MAP[i]) :
			return i
	return -1

func _process(delta):
	if state == IDLE :
		move()

func move() :
	var directionInput = get_movement_input()
	if directionInput == -1 : return
	direction = directionInput
	state = WALK
	var path = DIR2VEC[directionInput] * MOTION_DISTANCE
	var tween = create_tween()
	tween.tween_property(self, "position", path, MOTION_DURATION).as_relative()
	tween.set_loops(2)
	tween.play()
	animation_state(direction, WALK)
	var loopNumber = 2
	while true :
		await tween.step_finished
		directionInput = get_movement_input()
		if directionInput != direction : break
		loopNumber += 1
		tween.set_loops(loopNumber)
	
	tween.kill()
	tween = null
	state = IDLE
	animation_state(direction, IDLE)

func animation_state(direction : int, state : int) :
	var animation : String = ""
	match state :
		IDLE : animation = "idle_"
		WALK : animation = "walk_"
	animation += DIR2STR[direction]
	self.animation = animation
