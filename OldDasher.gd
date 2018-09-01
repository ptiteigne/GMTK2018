extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (int) var SPEED
export (float) var DASHLENGTH
export (float) var DASHTIME
export (float) var COOLDOWN
export (int) var DETECTRADIUS

var on_dash = false
var dash_is_beginning = false

var motion = Vector2(0,0)

var i = 0

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func _physics_process(delta):
    var player = get_node("../Player")

    # Exit execution if there is no player
    if player == null:
        return

    # If we're not dashing...
    elif !on_dash:
        # Check if dashing is necessary
        if player.position.distance_to(position) <= DETECTRADIUS:
            on_dash = true
            dash_is_beginning = true
        # ... or move normally
        else:
            motion = player.position - position
            motion = motion.normalized() * SPEED

    if on_dash:
        print("GO")

        if dash_is_beginning:
            motion = player.position - position
            motion = motion.normalized() * DASHSPEED
            dash_is_beginning = false

        i += 1
        if i > COOLDOWN:
            i = 0
            on_dash = false


    move_and_slide(motion)