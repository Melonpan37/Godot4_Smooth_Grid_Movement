extends Node2D #edit with the type of your node

#enum that describes all moving directions 
enum {UP, RIGHT, DOWN, LEFT}

#maps direction enum to unit vectors of all possible directions
const DIR2VEC = [			
	Vector2.UP,
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT,
]

#maps direction enum into strings representing keyboard inputs
const MOVE_INPUT_MAP = [		
	"ui_up",
	"ui_right",
	"ui_down",
	"ui_left"
]


const MOTION_DISTANCE : int = 16 	#edit with your own single step distance
const MOTION_DURATION : int = 0.15 	#this is the speed of a single step. you can set this as a variable if needed

enum {IDLE, WALK}			#movement states			
var state = IDLE			#movement state

#checks for directional inputs 
#returns -1 if no directional input is pressed
func get_movement_input() -> int :	
	for direction in range(MOVE_INPUT_MAP.size()) :
		if Input.is_action_pressed(MOVE_INPUT_MAP[direction]) :
			return direction
	return -1 #no directional input pressed

func _process(delta):
	if state == IDLE :
		move()

func move() :
	var direction = get_movement_input() 	#gets directional input
	if direction == -1 : return		#no directional input pressed
	state = WALK				#updates the state
	var path = DIR2VEC[direction] * MOTION_DISTANCE
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
