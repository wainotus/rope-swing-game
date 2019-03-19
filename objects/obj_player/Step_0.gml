/// @desc movement
grounded = (place_meeting(x,y+1,obj_wall));

var key_left = keyboard_check(ord("A"));
var key_right = keyboard_check(ord("D"));
var key_jump = keyboard_check_pressed(vk_space);
var key_down = keyboard_check(ord("S"));
var key_up = keyboard_check(ord("W"));


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
		
		if (mouse_check_button_pressed(mb_left))
		{
			grappleX = mouse_x;
			grappleY = mouse_y;
			ropeX = x;
			ropeY = y;
			ropeAngleVelocity = 0;
			ropeAngle = point_direction(grappleX,grappleY,x,y);
			ropeLength = point_distance(grappleX,grappleY,x,y);
			state = pState.swing;
		}
	}
	break;
	
	case pState.swing:
	{ 
		var ropeAngleAcceleration = -0.2 * dcos(ropeAngle);
		ropeAngleAcceleration += (key_right - key_left) * 0.08;
		ropeLength += (key_down - key_up) * 2;
		ropeLength = max(ropeLength,0);
		ropeAngleVelocity += ropeAngleAcceleration;
		ropeAngle += ropeAngleVelocity;
		ropeAngleVelocity *= 0.99;
		
		ropeX = grappleX + lengthdir_x(ropeLength, ropeAngle);
		ropeY = grappleY + lengthdir_y(ropeLength, ropeAngle);
		
		hSpeed = ropeX - x;
		vSpeed = ropeY - y;
		
		if (key_jump)
		{
			state = pState.normal;
			vSpeedFraction = 0;
			vSpeed = -jumpSpeed;
		}
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
	if (state == pState.swing)
	{
		ropeAngle = point_direction(grappleX,grappleY,x,y);
		ropeAngleVelocity = 0;
	}
}
x += hSpeed;

if (place_meeting(x,y+vSpeed,obj_wall))
{
	var vStep = sign(vSpeed);
	vSpeed = 0;
	vSpeedFraction = 0;
	while(!place_meeting(x,y+vStep,obj_wall)) y += vStep;
	if (state == pState.swing)
	{
		ropeAngle = point_direction(grappleX,grappleY,x,y);
		ropeAngleVelocity = 0;
	}
}
y += vSpeed;