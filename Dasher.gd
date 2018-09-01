extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (int) var SPEED
export (float) var DASHLENGTH
export(float) var WARMUP
export (float) var DASHTIME
export (float) var COOLDOWN
export (int) var DETECTRADIUS

var on_dash = false
var dash_begins = false
var dash_has_begun = false

var motion = Vector2(0,0)

var dash_timer = 0

var player

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    player = get_node("/root/Main/Player")

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

## Return Length * cos(t) with t varying from 0 to max_t
# Used here to simulate a decreasing velocity 
func _cos_interpolation(t, max_t, length):
    return length * cos((t*PI/2)/max_t)
    

func _physics_process(delta):
    
    # No physics process if player has disappeared
    player = get_node("/root/Main/Player")
    if player == null:
        return
        
    # Check if dasher near player
    if !on_dash && player.position.distance_to(position) <= DETECTRADIUS:
        on_dash = true
        dash_timer = 0
    
    # If not near, approach player normally
    if !on_dash:
        motion = player.position - position
        motion = motion.normalized() * SPEED
    
    # If near, engage or continue dashing
    else:
        dash_timer += delta
        
        # If dash just began, warm up : aim for player and don't move
        if dash_timer <= WARMUP:
            motion = player.position - position
            return
        # If warm up finished, dash
        elif dash_timer <= WARMUP + DASHTIME:
            var t = dash_timer - WARMUP
            # motion = motion.normalized() * _cos_interpolation(t, DASHTIME, DASHLENGTH) * delta * (PI/2) / DASHTIME
            motion = motion.normalized() * DASHLENGTH * (PI/(2*DASHTIME)) * cos(t * (PI/2) / DASHTIME)
            
            
        # If dash finished, cool down
        elif dash_timer <= WARMUP + DASHTIME + COOLDOWN:
            motion = Vector2(0,0)
            pass
            
        else:
            on_dash = false
        
    move_and_slide(motion)
        
    