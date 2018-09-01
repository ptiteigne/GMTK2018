extends KinematicBody2D

export (int) var speed
var activeDash = true
var screensize
var dashLength = 10

func _ready():
    screensize = get_viewport_rect().size

func _process(delta):
    var velocity = Vector2()
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if (Input.is_action_just_pressed("ui_select") && activeDash && velocity.length() != 0):
        activeDash = false
        $DashingTimer.start()
        for i in range(1,80):
            
            print(i)
        $DashResetTimer.start()
    if velocity.length() > 0:
        velocity = velocity.normalized()
        velocity = velocity * speed
    position += velocity * delta
    position.x = clamp(position.x, 0, screensize.x)
    position.y = clamp(position.y, 0, screensize.y)
    

func _on_DashTimer_timeout():
    activeDash = true


func _on_DashingTimer_timeout():
    #velocity = velocity * dashLength/i
    pass # replace with function body
