pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- space shooter
-- by vanawy

function _init()
 init_game()
end
-->8
-- game state

function init_game()
 _draw=draw_game
 _update=update_game
 
 score=0
 for i=1,3 do
 	for j=1,2 do
 		enemy(32+i*9,16+j*9)
 	end
 end
 player=make_player(56,112)
end

function update_game()
	foreach(enemies,e_upd)
	foreach(bullets,b_upd)
	player.upd()
end

function draw_game()
	cls()
	print("🐱 "..score,10,10,7)
	print(player.hp)
	print(time())
	foreach(enemies,e_draw)
	foreach(bullets,b_draw)
	player.draw()
end

-->8
--enemies
enemies={}

function enemy(x,y)
	local e={
	 x=x,
	 y=y,
	 w=8,
	 h=8,
	 reward=100,
	 hp=1,
	 sprite=2,
	 rate=1,
	 last_shot=time(),
	 swarm=false,
	 ai=ai_patrol
	}
	add(enemies,e)
end

function e_draw(e)
	spr(e.sprite,e.x,e.y)
end
function e_upd(e)
 --death
 if(e.hp<=0) then
  del(enemies,e)
  score+=e.reward
 end
 --shooting
 if(time()>e.last_shot+e.rate) then
  e_shot(e)
 end
 --ai
 e.ai(e)
end
function e_shot(e)
	e.last_shot=time()+rnd()
	bullet(e.x+e.w/2,e.y+e.h,true)
end
-->8
-- player
bullets={}
blt_spd=1


function make_player(x,y)
	local p={
		x=x,
		y=y,
		w=8,
		h=8,
		sprite=1,
		hp=3,
	 rate=0.7,
	 last_shot=time()+rnd(5),
	 spd=2,
	}
	
	function p.upd()
		if(btn(⬅️)) p.x-=p.spd
		if(btn(➡️)) p.x+=p.spd
		if(btn(❎) and p.can_shoot()) then
		 p.shot()
		end
		
		p.x=range(p.x,0,128-p.w)
	end
	
	function p.can_shoot()
	 return time()>p.last_shot+p.rate
	end
	
	function p.draw()
	 spr(p.sprite,p.x,p.y)
	end
	
	function p.shot()
		bullet(p.x+p.w/2,p.y)
		p.last_shot=time()
	end
	
	return p
end


function bullet(x,y,e)
 local b={
  x=x,
  y=y,
  e=e or false
 }
 add(bullets,b)
end

function b_upd(b)
 if(b.e) then
 	b.y+=blt_spd
  b_hit(b,player)
 else
 	b.y-=blt_spd
  for e in all(enemies) do
   b_hit(b,e)
  end
 end
end

function b_hit(b,t)
 if(b.y<t.y or b.y>t.y+t.h
 	or b.x<t.x or b.x>t.x+t.w) then
 	return
 end
 t.hp-=1
 del(bullets,b)
end

function b_draw(b)
 local c=7
 if(b.e) c=8
 pset(b.x,b.y,c)
end
-->8
--misc

function range(v,a,b)
 return max(a,min(b,v))
end

function animate(start,len,frames,inc)
 return start+(inc or 1)
  *((frame/frames or 1)%len)
end

function mapvalue(v,a,b,ta,tb)
 return ta+(v-a)/(b-a)*(tb-ta)
end
-->8
-- ai

-- aptrol_ai
local states={
	⬇️,⬅️,⬆️,➡️
}

local state=1
local last=time()
local rate=0.4
local spd=1

function ai_patrol(e)
 if(states[state]==⬅️) e.x-=spd
 if(states[state]==⬆️) e.y-=spd
 if(states[state]==➡️) e.x+=spd
 if(states[state]==⬇️) e.y+=spd
 
 if(last+rate>time()) return
 last=time()
 state+=1;
 if(state>#states) state=1
end
__gfx__
00000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660000040040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000cc000404aa40400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000005cc50049a98a9400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770008057750849a89a9400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070055677655404aa40400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000556666550008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000506006050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
