
-- == Section COOK Improvements == --
local cook_enabled = true
local item_array = {}

gm.post_script_hook(gm.constants.item_spawn_init , function(self, other, result, args)
    if self~= nil then table.insert(item_array,#item_array+1, self) end
end)

gm.pre_script_hook(gm.constants.__input_system_tick, function()
	if cook_enabled then
		for _, item in ipairs(item_array) do
            if item.item_stack_kind == 2.0 then
                item.item_stack_kind = 1.0
            end
        end
        item_array = {}
	end
end)

-- == Section GLAZE + SEAR Fix == --
local sear_enabled = true

gm.post_script_hook(gm.constants.damager_calculate_damage, function(self, other, result, args)
    if not sear_enabled then return false
    local target = args[2].value or args[3].value
    local oP = args[6].value
    local attack_flag = args[8].value -- this changes depending on the skill used
    if target == nil or gm.typeof(oP) ~= "struct" then return end
    if oP.name == 'CHEF' and attack_flag == 4.0 and target.buff_stack[19] == 1.0 then
        gm.apply_buff(target, 10, 120.0, 1) -- apply stun
    end
end)
