local MOD_NAME = minetest.get_current_modname() or "exertion";
local MOD_PATH = minetest.get_modpath(MOD_NAME);

local exertion = { MOD_NAME = MOD_NAME, MOD_PATH = MOD_PATH };
_G[MOD_NAME] = exertion;


local function callFile(fileName, ...)
   local chunk, err = loadfile(MOD_PATH .. "/" .. fileName);
   if not chunk then error(err); end;
   return chunk(...);
end;


local settings = callFile("loadSettings.lua", exertion);
exertion.settings = settings;


local PlayerState = callFile("PlayerState.lua", exertion);
exertion.PlayerState = PlayerState;


PlayerState.load();
local playerStates = {};
exertiontmp={}
exertionfood=""

--- Retrieves the PlayerState object for a given player.  Returns nil if player
 -- is not logged in.
 --
 -- @param player
 --    A player object or player name.
 --
function exertion.getPlayerState(player)
   if type(player) == 'string' then
      player = minetest.get_player_by_name(player);
   end;
   return playerStates[player];
end;

minetest.register_on_joinplayer(
   function(player)
      minetest.after(
         0, function() playerStates[player] = PlayerState(player); end);
   end);

minetest.register_on_leaveplayer(
   function(player)
      playerStates[player] = nil;
   end);

minetest.register_on_dieplayer(
   function(player)
      local ps = playerStates[player];
      if not ps then return; end;
      ps:setFed(2, true);
      ps:setHydrated(2, true);
      ps:setPoisoned(0, true);
      ps:clearExertionStats();
      ps:updateHud();
   end);

minetest.register_on_shutdown(PlayerState.save);

minetest.register_on_dignode(
   function(pos, oldNode, digger)
      local ps = playerStates[digger];
      if ps then ps:markBuildAction(oldNode); end;
   end);

minetest.register_on_placenode(
   function(pos, newNode, placer, oldNode, itemStack, pointedThing)
      local ps = playerStates[placer];
      if ps then ps:markBuildAction(newNode); end;
   end);

local controlPeriod = settings.controlTestPeriod_seconds;
local updatePeriod = settings.accountingPeriod_seconds;
local savePeriod = settings.savePeriod_seconds;
local controlTime = 0.0;
local updateTime = 0.0;
local saveTime = 0.0;
minetest.register_globalstep(
   function(dt)
      controlTime = controlTime + dt;
      if controlTime >= controlPeriod then
         for _, ps in pairs(playerStates) do
            ps:pollForActivity();
         end;
         controlTime = 0;
      end;

      updateTime = updateTime + dt;
      if updateTime >= updatePeriod then
         controlPeriod = settings.controlTestPeriod_seconds;
         updatePeriod = settings.accountingPeriod_seconds;
         local tw = os.time();
         for _, ps in pairs(playerStates) do
            ps:update(tw, updateTime);
         end;
         updateTime = 0;
      end;

      saveTime = saveTime + dt;
      if saveTime >= savePeriod then
         savePeriod = settings.savePeriod_seconds;
         PlayerState.save();
         saveTime = 0;
      end;
   end);

minetest.register_on_item_eat(
   function(hpChange, replacementItem, itemStack, player, pointedThing)
      if itemStack:take_item() ~= nil then
         local ps = playerStates[player];
         if ps then
            if hpChange > 0 then
		local dez=math.floor((hpChange-math.floor(hpChange))*10000+1)
		dez=(dez-dez%10)/10000
               local pp = 0
	       local water=0
	       local ph=0
		    if dez>0 then 
			water=math.floor(dez*10)
			hpChange=math.floor(hpChange)
			dez=dez-water/10
		    if dez>0 then 
			pp=math.floor(dez*100)
			dez=dez-pp/100
			pp=(pp*pp)/81
		    if dez>0 then 
			ph=math.floor(dez*1000)
			ph=(ph*ph)/81
			end
		    end
		    end
	
        	    if math.random() <= 1.0 - pp then
                  	  local update = false;
	                  update = ps:addFood(hpChange, true) or update;
	                  update = ps:addWater(water, true) or update;
        	   	  if update then ps:updateHud(); end;
	               if math.random() <= ph or hpChange>18 then
        		          ps:addPoison(-1);
		       end		
        	  else
                 	 minetest.chat_send_player(player:get_player_name(),
                              settings.foodPoisoningMessage);
                 	 ps:addPoison(2);
	          end;
            elseif hpChange < 0 then
               minetest.chat_send_player(player:get_player_name(),
                                         settings.poisoningMessage);
	                  ps:addHp(hpChange)
               ps:addPoison(-hpChange);
            end;
	end;
         itemStack:add_item(replacementItem);
      end;
      return itemStack;
   end)

