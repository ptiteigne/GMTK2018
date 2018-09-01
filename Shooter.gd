extends KinematicBody2D

export (int) var SPEED
export (int) var DETECTRADIUS
export (float) var RELOADTIME
export (int) var OFFSETSHOOT
export (int) var BULLETSPEED

export (PackedScene) var Bullet


var motion = Vector2(0,0)

var player

var shooting = false
var shoot_timer = 0

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    player = get_node("/root/Main/Player")
    

func _physics_process(delta):
    
    # No physics process if player has disappeared
    player = get_node("/root/Main/Player")
    if player == null:
        return
        
    # Check if shooter near player
    if !shooting && player.position.distance_to(position) <= DETECTRADIUS:
        shooting = true
    elif shooting:
        shoot_timer += delta
        
        if shoot_timer >= RELOADTIME:
            print("SHOOT!")
            var bullet = Bullet.instance()
            add_child(bullet)
            var vect_to_player = player.position - position
            var bullet_position = position + vect_to_player.normalized() * OFFSETSHOOT
            #var bullet_position = position
            bullet.global_position = bullet_position
            bullet.global_rotation = vect_to_player.angle()
            bullet.set_linear_velocity(vect_to_player.normalized() * BULLETSPEED)
            print(bullet)
            shoot_timer = 0
            
        else:
            shooting = false
        
    else:
        motion = player.position - position
        motion = motion.normalized() * SPEED
        move_and_slide(motion)
        
    