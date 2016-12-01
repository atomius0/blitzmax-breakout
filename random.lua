-- simple clone of function Rnd from BlitzMax's module BRL.Random

function rnd(min_value, max_value)
	min_value = min_value or 1
	max_value = max_value or 0
	
	local m = 10000000000000 -- multiplier: 13 x zero
	return math.random(min_value * m, max_value * m) / m
end