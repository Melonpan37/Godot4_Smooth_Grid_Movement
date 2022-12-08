extends Sprite2D


const MOVE_INPUT_MAP = [
	"ui_up",
	"ui_right",
	"ui_down",
	"ui_left"
]


const MOTION_DISTANCE = Consts.CELL_SIZE
const MOTION_DURATION = 0.15

enum {IDLE, WALK}
var state = IDLE

func get_movement_input() -> int :
	for i in range(MOVE_INPUT_MAP.size()) :
		if Input.is_action_pressed(MOVE_INPUT_MAP[i]) :
			return i
	return -1

func _process(delta):
	if state == IDLE :
		move()

func move() :
	var direction = get_movement_input()
	if direction == -1 : return
	state = WALK
	var path = Consts.DIR2VEC[direction] * MOTION_DISTANCE
	var tween = create_tween()
	tween.tween_property(self, "position", path, MOTION_DURATION).as_relative()
	tween.set_loops(2)
	tween.play()
	var originalDirection = direction
	var loopNumber = 2
	while true :
		await tween.step_finished
		direction = get_movement_input()
		if direction != originalDirection : break
		loopNumber += 1
		tween.set_loops(loopNumber)
	
	tween.kill()
	tween = null
	state = IDLE
