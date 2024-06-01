local Deepcopy = {}

function Deepcopy:Copy(original)
    local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = Deepcopy:Copy(v)
		end
		copy[k] = v
	end
	return copy
end

return Deepcopy