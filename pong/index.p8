pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
function _init()
	_draw=menu_draw
	_update=menu_update
	
	menu={
		"1 player 🐱",
		"2 players 🐱🐱"
	}
	sel=1
end

function menu_draw()
 cls(3)
 print(pong(),40,40,7)
 for k, v in pairs(menu) do
  c=6
  if(sel==k) c=7
  print(v,32,40+k*8,c)
 end
end

function menu_update()
 -- update menu
 if(btnp(⬇️) or btnp(⬇️,1)) sel+=1
 if(btnp(⬆️) or btnp(⬆️,1)) sel-=1
 if(sel<1) sel=#menu
 if(sel>#menu) sel=1
 
 --select menu
 if(btnp(❎) or btnp(❎,1) 
  or btnp(🅾️) or btnp(🅾️,1)) then
  
	 if(sel==1) then
	  init_game()
	 end
	 if(sel==2) then
	  init_game(true)
	 end
	 if(sel==3) then
	  init_help()
	 end
	end
end

function pong()
 local n=abs(5-flr(2*time())%10)
 local res="on"
 for i=1,n do
  res=" "..res
 end
 for i=n,4 do
  res=res.." "
 end
 return "p"..res.."g"
end
-->8
-- game state

function init_game(mp)
 _draw=game_draw
 _update=game_update
 
 multiplayer=mp or false
 p_speed=1
 p1_score=0
 p2_score=0
 setup()
end

function setup()
 p1=paddle(10,64) 
 p2=paddle(118,64) 
 b=ball()
end

function game_draw()
 cls()
 p1.draw()
 p2.draw()
 b.draw()
 draw_score()
end

function game_update()
 if(multiplayer) then
  input(p1,1)
 else
 	ai(p1)
 end
 input(p2)
 b.update()
 p1.update()
 p2.update()
 if(b.x>128) then
  p1_score+=1
  setup()
 end
 if(b.x+b.w<0) then
  p2_score+=1
  setup()
 end
 if(p1_score>9) then
  game_over("player 1 wins")
 end
 if(p2_score>9) then
  game_over("player 2 wins")
 end
end

function ball()
 local b={
  x=64,
  y=64,
  w=2,
  h=2,
  dx=0,
  dy=0,
 }
 if(rnd()>0.5) then
 	b.dx=-1 
 else 
 	b.dx=1
 end
 
 function b.redirect(p)
  b.dx=-b.dx
  
  local d=(b.y+b.h/2)-(p.y+p.h/2)
  print(d)
  if(d>0) then
   b.dy=1
  else 
  	b.dy=-1
  end
 end
 function b.draw()
  rectfill(b.x,b.y,
   b.x+b.w,b.y+b.h,7)
 end
 function b.update()
  b.x+=b.dx
  b.y+=b.dy
  if(b.y<0) then
   b.y=0
   b.dy=-b.dy
  end
  if(b.y+b.h>128)then
   b.y=128-b.h
   b.dy=-b.dy
  end
 end
 return b
end

function paddle(x,y)
 local h=12
 local p={
  x=x,
  y=y-h/2,
  w=2,
  h=h
 }
 function p.draw()
  rectfill(p.x,p.y,
   p.x+p.w,p.y+p.h,7)
 end
 function p.update()
  if(p.y+p.h>128) p.y=128-p.h
  if(p.y<0) p.y=0
  p.hit(b)
 end
 -- hit with a ball
 function p.hit(b)
  if(p.x+p.w<b.x or p.y+p.h<b.y
   or p.x>b.x+b.w or p.y>b.y+b.w) then
   return
  end
  b.redirect(p)  
 end
 return p
end

function input(p,n)
 if(btn(⬆️,n or 0)) p.y-=p_speed
 if(btn(⬇️,n or 0)) p.y+=p_speed
end

function draw_score()
 local s1=p1_score
 local s2=p2_score
 sspr(8*s1,0,8,8,16,16,16,16)
 sspr(8*s2,0,8,8,96,16,16,16)
end
-->8
-- game over state

function game_over(text)
 _draw=over_draw
 _update=over_update
 
 t=text
end

function over_draw()
 cls(3)
 print(t,64-#t*2,16,7)
 print("❎ - new game")
end

function over_update()
 if(btnp(❎)) _init()
end

 
-->8
-- ai 🅾️_🅾️
function ai(pad)
 if(rnd()>0.5) then
 	pad.y+=p_speed
 else
 	pad.y-=p_speed
 end
end
__gfx__
00777700007770000077770000777700007007000077770000777700007777000077770000777700007777000000000000000000000000000000000000000000
00700700000770000000070000000700007007000070000000700000000007000070070000700700007007000000000000000000000000000000000000000000
00700700000770000000070000000700007007000070000000700000000007000070070000700700007007000000000000000000000000000000000000000000
00700700000770000000070000000700007007000070000000700000000007000070070000700700007007000000000000000000000000000000000000000000
00700700000770000077770000777700007777000077770000777700000007000077770000777700007007000000000000000000000000000000000000000000
00700700000770000070000000000700000007000000070000700700000007000070070000000700007007000000000000000000000000000000000000000000
00700700000770000077770000000700000007000000070000700700000007000070070000000700007007000000000000000000000000000000000000000000
00777700007777000077770000777700000007000077770000777700000007000077770000777700007777000000000000000000000000000000000000000000
