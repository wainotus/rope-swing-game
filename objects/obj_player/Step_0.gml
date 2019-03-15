/// @desc movement
grounded = (place_meeting(x,y+1,obj_wall));

var key_left = keyboard_check(ord("A"));
var key_right = keyboard_check(ord("D"));
var key_jump = keyboard_check_pressed(vk_space);


switch (state)
{
	case pState.normal:
	{
		var dir = key_right - key_left;
		hSpeed += dir * walkAcceleration
		
		if (dir == 0)
		{
			var hFriction = hFrictionGround;
			if (!grounded) hFriction = hFrictionAir;
			hSpeed = Approach(hSpeed,0,hFriction);
		}
		hSpeed = clamp(hSpeed,-walkSpeed,walkSpeed);
		
		vSpeed += gravity_;
		
		if (key_jump) && (grounded)
		{
			grounded = false;
			vSpeedFraction = 0;
			vSpeed = -jumpSpeed;
		}
	}
	break;
	
	case pState.swing:
	{
		
	}
	break;
}

hSpeed += hSpeedFraction;
vSpeed += vSpeedFraction;
hSpeedFraction = frac(hSpeed);
vSpeedFraction = frac(vSpeed);
hSpeed -= hSpeedFraction;
hSpeed -= hSpeedFraction;

if (place_meeting(x+hSpeed,y,obj_wall))
{
	var hStep = sign(hSpeed);
	hSpeed = 0;
	hSpeedFraction = 0;
	while(!place_meeting(x+hStep,y,obj_wall)) x += hStep;
}
x += hSpeed;

if (place_meeting(x,y+vSpeed,obj_wall))
{
	var vStep = sign(vSpeed);
	vSpeed = 0;
	vSpeedFraction = 0;
	while(!place_meeting(x,y+vStep,obj_wall)) y += vStep;
}
y += vSpeed;