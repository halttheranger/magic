minetest.register_tool("magic:staff_wood", {
	description = "Wooden Staff",
	inventory_image = "magic_staff_wood_wield.png",
	wield_image = "magic_staff_wood_wield.png",
	wield_scale = {x=1.5,y=5.5,z=1.5},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=0,
		groupcaps={
			crumbly = {times={[1]=4.5, [2]=2.2, [3]=1.2}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	}
})

minetest.register_craft({
	output = 'magic_weapons:staff_wood',
	recipe = {
		{'default:wood'},
		{'default:stick'},
		{'default:wood'},
	}
})


















minetest.register_entity("magic:fireball", {
	textures = {"fireball.png"},
	velocity = 15,
	light_source = 200,
	on_step = function (self, pos, node, dtime)
				local pos = self.object:getpos()
					local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2) 
                for k, obj in pairs(objs) do
		obj:set_hp(obj:get_hp()-15)
                    if obj:is_player() then
                        return
                    else
                    obj:set_hp(obj:get_hp()-70)					
				    if obj:get_entity_name() ~= "magic:fireball" then
						if obj:get_hp()<=0 then 
							obj:remove()
						end
						self.object:remove() 
					end						
				end
            end

					for dx=-1,1 do
						for dy=-1,1 do
							for dz=-1,1 do
								local p = {x=pos.x+dx, y=pos.y, z=pos.z+dz}
								local t = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
								local n = minetest.env:get_node(p).name
--								if n ~= "magic:fireball" and n ~="hackersheep:hackersheep" and n ~="prohackersheep:prohackersheep"  then	
--									if   minetest.registered_nodes[n].groups.noobhackersheep then --[[or math.random(1, 100) <= 0]]
--										minetest.env:set_node(t, {name=""..n})
--									else 
--										minetest.env:set_node(t, {name=""..n})
--									end
--								else
if minetest.registered_nodes[n].groups.flammable or minetest.registered_nodes[n].groups.choppy or minetest.registered_nodes[n].groups.oddly_breakable_by_hand or minetest.registered_nodes[n].groups.cracky or minetest.registered_nodes[n].groups.crumbly or n =="default:desert_stone" then
									self.hit_node(self, pos, node)
									self.object:remove()
									return
								end
							end
						end
					end
	end,
	
	
	hit_node = function(self, pos, node)
	local pos = self.object:getpos()
--		for dx=-4,4 do
--			for dy=-4,4 do
--				for dz=-4,4 do
--					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
--					local t = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
--					local n = minetest.env:get_node(pos).name
--					if math.random(1, 50) <= 0 then
--						minetest.env:remove_node(p)
--					end
--					if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) >=500 then
--										minetest.env:set_node(t, {name="air"})
--					end
					local objects = minetest.env:get_objects_inside_radius(pos, 10)
											for _,obj in ipairs(objects) do
												if obj:is_player() or (obj:get_luaentity() and obj:get_luaentity().name ~= "__builtin:item") then
													local obj_p = obj:getpos()
													local vec = {x=obj_p.x-pos.x, y=obj_p.y-pos.y, z=obj_p.z-pos.z}
													local dist = (vec.x^2+vec.y^2+vec.z^2)^0.5
													local damage = ((80*0.5^dist)*2)+3
													obj:punch(obj, 1.0, {
													full_punch_interval=1.0,
													damage_groups={fleshy=damage},
													}, vec)
												end
										end

					minetest.add_particlespawner(
			10, --amount
			0.1, --time
			{x=pos.x-3, y=pos.y-3, z=pos.z-3}, --minpos
			{x=pos.x+3, y=pos.y+3, z=pos.z+3}, --maxpos
			{x=-0, y=-0, z=-0}, --minvel
			{x=0, y=0, z=0}, --maxvel
			{x=-0.5,y=5,z=-0.5}, --minacc
			{x=0.5,y=5,z=0.5}, --maxacc
			0.1, --minexptime
			1, --maxexptime
			50, --minsize
			90, --maxsize
			false, --collisiondetection
			"flame_pillar.png" --texture
		)
                        
--				end
--			end
--		end
	end
})
minetest.register_craftitem("magic:firestaff", {
	description = "Staff of Fire",
	inventory_image = "firestaff.png",
	wield_scale = {x=2.5,y=5.5,z=1.5},
	stackable = false,
	on_use = function (itemstack, placer, pointed_thing)
			local dir = placer:get_look_dir();
			local playerpos = placer:getpos();
			local obj = minetest.env:add_entity({x=playerpos.x+0+dir.x,y=playerpos.y+2+dir.y,z=playerpos.z+0+dir.z}, "magic:fireball")
			local vec = {x=dir.x*6,y=dir.y*6,z=dir.z*6}
			obj:setvelocity(vec)
		return itemstack
	end,
	light_source = 15,
})
local addvectors = function (v1, v2)
	return {x=v1.x+v2.x, y=v1.y+v2.y, z=v1.z+v2.z}
end



























minetest.register_entity("magic:magicmissile", {
	textures = {"magicmissile.png"},
	velocity = 15,
	light_source = 200,
	on_step = function (self, pos, node, dtime)
				local pos = self.object:getpos()
					local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2) 
                for k, obj in pairs(objs) do
		obj:set_hp(obj:get_hp()-5)
                    if obj:is_player() then
                        return
                    else
                    obj:set_hp(obj:get_hp()-10)					
				    if obj:get_entity_name() ~= "magic:magicmissile" then
						if obj:get_hp()<=0 then 
							obj:remove()
						end
						self.object:remove() 
					end						
				end
            end

					for dx=-1,1 do
						for dy=-1,1 do
							for dz=-1,1 do
								local p = {x=pos.x+dx, y=pos.y, z=pos.z+dz}
								local t = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
								local n = minetest.env:get_node(p).name
--								if n ~= "magic:fireball" and n ~="hackersheep:hackersheep" and n ~="prohackersheep:prohackersheep"  then	
--									if   minetest.registered_nodes[n].groups.noobhackersheep then --[[or math.random(1, 100) <= 0]]
--										minetest.env:set_node(t, {name=""..n})
--									else 
--										minetest.env:set_node(t, {name=""..n})
--									end
--								else
if minetest.registered_nodes[n].groups.flammable or minetest.registered_nodes[n].groups.choppy or minetest.registered_nodes[n].groups.oddly_breakable_by_hand or minetest.registered_nodes[n].groups.cracky or minetest.registered_nodes[n].groups.crumbly or n =="default:desert_stone" then
									self.hit_node(self, pos, node)
									self.object:remove()
									return
								end
							end
						end
					end
	end,
	
	
	hit_node = function(self, pos, node)
	local pos = self.object:getpos()
--		for dx=-4,4 do
--			for dy=-4,4 do
--				for dz=-4,4 do
--					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
--					local t = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
--					local n = minetest.env:get_node(pos).name
--					if math.random(1, 50) <= 0 then
--						minetest.env:remove_node(p)
--					end
--					if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) >=500 then
--										minetest.env:set_node(t, {name="air"})
--					end
					local objects = minetest.env:get_objects_inside_radius(pos, 2)
											for _,obj in ipairs(objects) do
												if obj:is_player() or (obj:get_luaentity() and obj:get_luaentity().name ~= "__builtin:item") then
													local obj_p = obj:getpos()
													local vec = {x=obj_p.x-pos.x, y=obj_p.y-pos.y, z=obj_p.z-pos.z}
													local dist = (vec.x^2+vec.y^2+vec.z^2)^0.5
													local damage = (10*0.5^dist)*1
													obj:punch(obj, 1.0, {
													full_punch_interval=1.0,
													damage_groups={fleshy=damage},
													}, vec)
												end
										end

					minetest.add_particlespawner(
			2, --amount
			0.1, --time
			{x=pos.x-0, y=pos.y-0, z=pos.z-0}, --minpos
			{x=pos.x+0, y=pos.y+0, z=pos.z+0}, --maxpos
			{x=-0, y=-0, z=-0}, --minvel
			{x=0, y=0, z=0}, --maxvel
			{x=-0.5,y=5,z=-0.5}, --minacc
			{x=0.5,y=5,z=0.5}, --maxacc
			0.1, --minexptime
			1, --maxexptime
			20, --minsize
			30, --maxsize
			false, --collisiondetection
			"magicmissileburst.png" --texture
		)
                        
--				end
--			end
--		end
	end
})
minetest.register_craftitem("magic:apprentice_staff", {
	description = "Staff of the Apprenti",
	inventory_image = "apprentice.png",
	wield_scale = {x=2.5,y=5.5,z=1.5},
	stackable = false,
	on_use = function (itemstack, placer, pointed_thing)
			local dir = placer:get_look_dir();
			local playerpos = placer:getpos();
			local obj = minetest.env:add_entity({x=playerpos.x+0+dir.x,y=playerpos.y+2+dir.y,z=playerpos.z+0+dir.z}, "magic:magicmissile")
			local vec = {x=dir.x*8,y=dir.y*8,z=dir.z*8}
			obj:setvelocity(vec)
		return itemstack
	end,
	light_source = 15,
})
local addvectors = function (v1, v2)
	return {x=v1.x+v2.x, y=v1.y+v2.y, z=v1.z+v2.z}
end


minetest.register_entity("magic:lightning", {
	textures = {"lightningball.png"},
	velocity = 15,
	light_source = 200,
	on_step = function (self, pos, node, dtime)
				local pos = self.object:getpos()
					local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2) 
                for k, obj in pairs(objs) do
		obj:set_hp(obj:get_hp()-10)
                    if obj:is_player() then
                        return
                    else
                    obj:set_hp(obj:get_hp()-20)					
				    if obj:get_entity_name() ~= "magic:lightning" then
						if obj:get_hp()<=0 then 
							obj:remove()
						end
						self.object:remove() 
					end						
				end
            end

					for dx=-1,1 do
						for dy=-1,1 do
							for dz=-1,1 do
								local p = {x=pos.x+dx, y=pos.y, z=pos.z+dz}
								local t = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
								local n = minetest.env:get_node(p).name
--								if n ~= "magic:fireball" and n ~="hackersheep:hackersheep" and n ~="prohackersheep:prohackersheep"  then	
--									if   minetest.registered_nodes[n].groups.noobhackersheep then --[[or math.random(1, 100) <= 0]]
--										minetest.env:set_node(t, {name=""..n})
--									else 
--										minetest.env:set_node(t, {name=""..n})
--									end
--								else
if minetest.registered_nodes[n].groups.flammable or minetest.registered_nodes[n].groups.choppy or minetest.registered_nodes[n].groups.oddly_breakable_by_hand or minetest.registered_nodes[n].groups.cracky or minetest.registered_nodes[n].groups.crumbly or n =="default:desert_stone" then
									self.hit_node(self, pos, node)
									self.object:remove()
									return
								end
							end
						end
					end
	end,
	
	
	hit_node = function(self, pos, node)
	local pos = self.object:getpos()
--		for dx=-4,4 do
--			for dy=-4,4 do
--				for dz=-4,4 do
--					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
--					local t = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
--					local n = minetest.env:get_node(pos).name
--					if math.random(1, 50) <= 0 then
--						minetest.env:remove_node(p)
--					end
--					if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) >=500 then
--										minetest.env:set_node(t, {name="air"})
--					end
					local objects = minetest.env:get_objects_inside_radius(pos, 4)
											for _,obj in ipairs(objects) do
												if obj:is_player() or (obj:get_luaentity() and obj:get_luaentity().name ~= "__builtin:item") then
													local obj_p = obj:getpos()
													local vec = {x=obj_p.x-pos.x, y=obj_p.y-pos.y, z=obj_p.z-pos.z}
													local dist = (vec.x^2+vec.y^2+vec.z^2)^0.5
													local damage = (80*0.5^dist)*2
													obj:punch(obj, 1.0, {
													full_punch_interval=1.0,
													damage_groups={fleshy=damage},
													}, vec)
												end
										end

					minetest.add_particlespawner(
			4, --amount
			0.1, --time
			{x=pos.x-3, y=pos.y-3, z=pos.z-3}, --minpos
			{x=pos.x+3, y=pos.y+3, z=pos.z+3}, --maxpos
			{x=-0, y=-0, z=-0}, --minvel
			{x=0, y=0, z=0}, --maxvel
			{x=-0.0,y=0,z=-0.0}, --minacc
			{x=0.1,y=-1,z=0.1}, --maxacc
			0.1, --minexptime
			1, --maxexptime
			300, --minsize
			350, --maxsize
			false, --collisiondetection
			"lightningbolt.png" --texture
		)
                        
--				end
--			end
--		end
	end
})
minetest.register_craftitem("magic:lightning_staff", {
	description = "Staff of the Vengeful Skies",
	inventory_image = "lightningstaff.png",
	wield_scale = {x=2.5,y=5.5,z=1.5},
	stackable = false,
	on_use = function (itemstack, placer, pointed_thing)
			local dir = placer:get_look_dir();
			local playerpos = placer:getpos();
			local obj = minetest.env:add_entity({x=playerpos.x+0+dir.x,y=playerpos.y+2+dir.y,z=playerpos.z+0+dir.z}, "magic:lightning")
			local vec = {x=dir.x*12,y=dir.y*12,z=dir.z*12}
			obj:setvelocity(vec)
		return itemstack
	end,
	light_source = 15,
})
local addvectors = function (v1, v2)
	return {x=v1.x+v2.x, y=v1.y+v2.y, z=v1.z+v2.z}
end














minetest.register_node("magic:light_still", {
	drawtype = "glasslike",
	tile_images = {"magic_light.png"},
	-- tile_images = {"magic_light_debug.png"},
	inventory_image = minetest.inventorycube("magic_light.png"),
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	light_propagates = true,
	sunlight_propagates = true,
	light_source = 13,
	selection_box = {
        type = "fixed",
        fixed = {0, 0, 0, 0, 0, 0},
    },
})

local players = {}
local player_positions = {}
local last_wielded = {}

function round(num) 
	return math.floor(num + 0.5) 
end

minetest.register_craftitem("magic:staff_light", {
	description = "Staff of Light",
	inventory_image = "lightstaff.png",
	wield_scale = {x=2.5,y=5.5,z=1.5},
	stackable = false,
})






























































































































minetest.register_entity("magic:elball", {
	visual = "mesh",
	visual_size = {x=5, y=5},
	mesh = "mosword_ball.x",
	textures = {"elball.png"},
	velocity = 0,
	light_source = 8,
	on_step = function(self, dtime)
			local pos = self.object:getpos()
			if minetest.env:get_node(self.object:getpos()).name ~= "air" then
				self.hit_node(self, pos, node)
				self.object:remove()
				return
			end
			pos.y = pos.y-1
			for _,player in pairs(minetest.env:get_objects_inside_radius(pos, 1)) do
				if player:is_player() then
					self.hit_player(self, player)
					self.object:remove()
					return
				end
			end
		end,
	hit_player = function(self, player)
		local s = player:getpos()
		local p = player:get_look_dir()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=5},
		}, vec)
		local pos = player:getpos()
		for dx=0,1 do
			for dy=0,1 do
				for dz=0,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(p).name
					if (n == "air") then
							minetest.env:set_node(p, {name="magic:static_energy"})
					end
				end
			end
		end
	end,
	hit_node = function(self, pos, node)
		for dx=-1,1 do
			for dy=-2,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(p).name
					if (n == "air") then
							minetest.env:set_node(p, {name="magic:static_energy"})
					end
				end
			end
		end
	end
})



minetest.register_tool("magic:elstaff", {
	description = "Staff of Electricity",
	inventory_image = "elstaff.png",
	on_use = function(itemstack, placer, pointed_thing)
			local dir = placer:get_look_dir();
			local playerpos = placer:getpos();
			local obj = minetest.env:add_entity({x=playerpos.x+0+dir.x,y=playerpos.y+2+dir.y,z=playerpos.z+0+dir.z}, "magic:elball")
			local vec = {x=dir.x*0,y=dir.y*0.0,z=dir.z*0}
			obj:setvelocity(vec)
		return itemstack
	end,
	light_source = 8,
})





lava = 5


minetest.register_node("magic:static_energy", {
	drawtype = "glasslike",
	tile_images = {"magic_light.png"},
	-- tile_images = {"magic_light_debug.png"},
	inventory_image = minetest.inventorycube("magic_light.png"),
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	light_propagates = true,
	sunlight_propagates = true,
	light_source = 13000000000000,
        damage_per_second = 4,
        walkable = false,
        pointable = false,
        diggable = false,
        buildable_to = true,
        is_ground_content = false,
	selection_box = {
        type = "fixed",
        fixed = {0, 0, 0, 0, 0, 0},
    },

})






minetest.register_entity("magic:lifeball", {
	visual = "mesh",
	visual_size = {x=5, y=5},
	mesh = "mosword_ball.x",
	textures = {"healingmagic.png"},
	velocity = 0,
	light_source = 20,
	on_step = function(self, dtime)
			local pos = self.object:getpos()
			if minetest.env:get_node(self.object:getpos()).name ~= "air" then
				self.hit_node(self, pos, node)
				self.object:remove()
				return
			end
			pos.y = pos.y-1
			for _,player in pairs(minetest.env:get_objects_inside_radius(pos, 1)) do
				if player:is_player() then
					self.hit_player(self, player)
					self.object:remove()
					return
				end
			end
		end,
	hit_player = function(self, player)
		local s = player:getpos()
		local p = player:get_look_dir()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=-20},
		}, vec)
		local pos = player:getpos()
		for dx=0,1 do
			for dy=0,1 do
				for dz=0,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(p).name
					if (n == "air") then
							minetest.env:set_node(p, {name="air"})
					end
				end
			end
		end
	end,
	hit_node = function(self, pos, node)
		for dx=-1,1 do
			for dy=-2,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(p).name
					if (n == "air") then
							minetest.env:set_node(p, {name="air"})
					end
				end
			end
		end
	end
})



minetest.register_tool("magic:lifestaff", {
	description = "Staff of Healing",
	inventory_image = "lifestaff.png",
	on_use = function(itemstack, placer, pointed_thing)
			local dir = placer:get_look_dir();
			local playerpos = placer:getpos();
			local obj = minetest.env:add_entity({x=playerpos.x,y=playerpos.y,z=playerpos.z}, "magic:lifeball")
			local vec = {x=dir.x*0,y=dir.y*0,z=dir.z*0}
			obj:setvelocity(vec)
		return itemstack
	end,
	light_source = 20,
})






























minetest.register_on_player_hpchange(function(player, hp_change)
local player_name = player:get_player_name()
	table.insert(players, player_name)
	last_wielded[player_name] = player:get_wielded_item():get_name()
	local pos = player:getpos()
	local rounded_pos = {x=round(pos.x),y=round(pos.y)+1,z=round(pos.z)}
        local player = minetest.env:get_player_by_name(player_name)
        local placer = player
		local wielded_item = player:get_wielded_item():get_name()
                if wielded_item == "magic:lifestaff" then
			if 101 > math.random(100) then
	local dir = placer:get_look_dir();
			local playerpos = placer:getpos();
			local obj = minetest.env:add_entity({x=playerpos.x,y=playerpos.y,z=playerpos.z}, "magic:lifeball")
			local vec = {x=dir.x*0,y=dir.y*0,z=dir.z*0}
			obj:setvelocity(vec)
		return itemstack
	        end		
	end
end)
















local players = {}
local player_positions = {}
local last_wielded = {}

function round(num) 
	return math.floor(num + 0.5) 
end

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	table.insert(players, player_name)
	last_wielded[player_name] = player:get_wielded_item():get_name()
	local pos = player:getpos()
	local rounded_pos = {x=round(pos.x),y=round(pos.y)+1,z=round(pos.z)}
	local wielded_item = player:get_wielded_item():get_name()
	if wielded_item ~= "magic:staff_light" and wielded_item ~= "magic:healing_orb" then
		minetest.env:add_node(rounded_pos,{type="node",name="default:cobble"})
		minetest.env:add_node(rounded_pos,{type="node",name="air"})
	end
	player_positions[player_name] = {}
	player_positions[player_name]["x"] = rounded_pos.x;
	player_positions[player_name]["y"] = rounded_pos.y;
	player_positions[player_name]["z"] = rounded_pos.z;
end)

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	for i,v in ipairs(players) do
		if v == player_name then 
			table.remove(players, i)
			last_wielded[player_name] = nil
			local pos = player:getpos()
			local rounded_pos = {x=round(pos.x),y=round(pos.y)+1,z=round(pos.z)}
			minetest.env:add_node(rounded_pos,{type="node",name="default:cobble"})
			minetest.env:add_node(rounded_pos,{type="node",name="air"})
			player_positions[player_name]["x"] = nil
			player_positions[player_name]["y"] = nil
			player_positions[player_name]["z"] = nil
			player_positions[player_name]["m"] = nil
			player_positions[player_name] = nil
		end
	end
end)

minetest.register_globalstep(function(dtime)
	for i,player_name in ipairs(players) do
		local player = minetest.env:get_player_by_name(player_name)
		local wielded_item = player:get_wielded_item():get_name()
		if wielded_item == "magic:staff_light" or wielded_item == "magic:healing_orb" then
			local pos = player:getpos()
			local rounded_pos = {x=round(pos.x),y=round(pos.y)+1,z=round(pos.z)}
			if (last_wielded[player_name] ~= "magic:staff_light" and last_wielded[player_name] ~= "magic:healing_orb") or (player_positions[player_name]["x"] ~= rounded_pos.x or player_positions[player_name]["y"] ~= rounded_pos.y or player_positions[player_name]["z"] ~= rounded_pos.z) then
				local is_air  = minetest.env:get_node_or_nil(rounded_pos)
				if is_air == nil or (is_air ~= nil and (is_air.name == "air" or is_air.name == "magic:light")) then
					minetest.env:add_node(rounded_pos,{type="node",name="magic:light"})
				end
				if (player_positions[player_name]["x"] ~= rounded_pos.x or player_positions[player_name]["y"] ~= rounded_pos.y or player_positions[player_name]["z"] ~= rounded_pos.z) then
					local old_pos = {x=player_positions[player_name]["x"], y=player_positions[player_name]["y"], z=player_positions[player_name]["z"]}
					local is_light = minetest.env:get_node_or_nil(old_pos)
					if is_light ~= nil and is_light.name == "magic:light" then
						minetest.env:add_node(old_pos,{type="node",name="default:cobble"})
						minetest.env:add_node(old_pos,{type="node",name="air"})
					end
				end
				player_positions[player_name]["x"] = rounded_pos.x
				player_positions[player_name]["y"] = rounded_pos.y
				player_positions[player_name]["z"] = rounded_pos.z
			end

			last_wielded[player_name] = wielded_item;
		elseif last_wielded[player_name] == "magic:staff_light" or last_wielded[player_name] == "magic:healing_orb" then
			local pos = player:getpos()
			local rounded_pos = {x=round(pos.x),y=round(pos.y)+1,z=round(pos.z)}
			repeat
				local is_light  = minetest.env:get_node_or_nil(rounded_pos)
				if is_light ~= nil and is_light.name == "magic:light" then
					minetest.env:add_node(rounded_pos,{type="node",name="default:cobble"})
					minetest.env:add_node(rounded_pos,{type="node",name="air"})
				end
			until minetest.env:get_node_or_nil(rounded_pos) ~= "magic:light"
			local old_pos = {x=player_positions[player_name]["x"], y=player_positions[player_name]["y"], z=player_positions[player_name]["z"]}
			repeat
				is_light  = minetest.env:get_node_or_nil(old_pos)
				if is_light ~= nil and is_light.name == "magic:light" then
					
					minetest.env:add_node(old_pos,{type="node",name="default:cobble"})
					minetest.env:add_node(old_pos,{type="node",name="air"})
				end
			until minetest.env:get_node_or_nil(old_pos) ~= "magic:light"
			last_wielded[player_name] = wielded_item
		end
	end
end)

minetest.register_node("magic:light", {
	drawtype = "glasslike",
	tile_images = {"magic_light.png"},
	-- tile_images = {"magic_light_debug.png"},
	inventory_image = minetest.inventorycube("magic_light.png"),
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	light_propagates = true,
	sunlight_propagates = true,
	light_source = 13,
	selection_box = {
        type = "fixed",
        fixed = {0, 0, 0, 0, 0, 0},
    },
})

