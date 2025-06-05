--[[
------------------------------Basic Table of Contents------------------------------
Line 17, Atlas ---------------- Explains the parts of the atlas.
Line 29, Joker 2 -------------- Explains the basic structure of a joker
Line 88, Runner 2 ------------- Uses a bit more complex contexts, and shows how to scale a value.
Line 127, Golden Joker 2 ------ Shows off a specific function that's used to add money at the end of a round.
Line 163, Merry Andy 2 -------- Shows how to use add_to_deck and remove_from_deck.
Line 207, Sock and Buskin 2 --- Shows how you can retrigger cards and check for faces
Line 240, Perkeo 2 ------------ Shows how to use the event manager, eval_status_text, randomness, and soul_pos.
Line 310, Walkie Talkie 2 ----- Shows how to look for multiple specific ranks, and explains returning multiple values
Line 344, Gros Michel 2 ------- Shows the no_pool_flag, sets a pool flag, another way to use randomness, and end of round stuff.
Line 418, Cavendish 2 --------- Shows yes_pool_flag, has X Mult, mainly to go with Gros Michel 2.
Line 482, Castle 2 ------------ Shows the use of reset_game_globals and colour variables in loc_vars, as well as what a hook is and how to use it.
--]]

--Creates an atlas for cards to use
SMODS.Atlas {
	-- Key for code to find it with
	key = "ModdedVanilla",
	-- The name of the file, for the code to pull the atlas from
	path = "ModdedVanilla.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}





SMODS.Sound{
	key = 'bad_seal',
	path = 'bad_seal.ogg'
}


SMODS.Seal {
	name = "useless-seal",
	key = "useless_seal",
	badge_colour = HEX("b2112a"),
	atlas = "ModdedVanilla",
	pos = {x=0, y=1},

	config = {
		mult = 5, chips = 20, money = 1, x_mult = 1.5
	},
	loc_txt = {
		-- Badge name (displayed on card description when seal is applied)
		label = 'Useless Seal',
		-- Tooltip description
		name = 'Useless Seal',
		text = {
			'{C:red}Debuffs{} this card'
		}
	},
	loc_vars = function(self, info_queue)
		return { vars = {self.config.mult, self.config.chips, self.config.money, self.config.x_mult, } }
	end,


	-- self - this seal prototype
	-- card - card this seal is applied to
	calculate = function(self, card, context)
		card:set_debuff(true)
	end,
}

SMODS.Joker {
	key = 'useless',
	loc_txt = {
		name = 'Hopeless Joker',
		text = {
			"Buy it for the bit."
		}
	},
	    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('debuff', nil, card.ARGS.send_to_shader)
        end
    end,
	config = { extra = { chips = 0, chip_gain = 15 } },
	rarity = 1,
	atlas = 'ModdedVanilla',
	pos = { x = 1, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,
	calculate = function(self, card, context)

        if context.before and context.main_eval and not context.blueprint then

			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.03, func = function(i,v)
				for i,v in ipairs(context.scoring_hand) do
					v:flip()
				end
				return true
			end}))

			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.03, func = function(i,v)
				for i,v in ipairs(context.scoring_hand) do
					v:set_seal('mvan_useless_seal', true)
					play_sound('mvan_bad_seal', 1, 0.55)
					v:juice_up()
				end
				return true
			end}))

			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.03, func = function(i,v)
				for i,v in ipairs(context.scoring_hand) do
					v:flip()
				end
				return true
			end}))

		end
	end
}


SMODS.Sound{
	key = 'chomp',
	path = 'chomp.ogg'
}
SMODS.Sound{
	key = 'hunger',
	path = 'hunger.ogg'
}
SMODS.Sound{
	key = 'ah',
	path = 'ah.ogg'
}

SMODS.Joker {
	key = 'cat',
	loc_txt = {
		name = 'THE CAT',
		text = {
    		"Consumes the {E:2,C:attention}Joker{} to its right",
    		"after a hand is played,",
			"gaining {E:2,C:attention}+1 Food{} per {E:2,C:attention}Joker{} consumed.",
			"Loses {E:2,C:attention}1 Food{} when a Blind is selected.",
			"You {S:1.1,C:red,E:1}lose the run{} if it runs out of {E:2,C:attention}Food{}.",
			"You also {S:1.1,C:red,E:1}lose the run{} if it has too much {E:2,C:attention}Food{}.",
			"{E:2,C:attention}Current Food: #1#{}",
		}
	},
	rarity = 1,
	atlas = 'ModdedVanilla',
	pos = { x = 2, y = 0 },
	cost = 5,
	config = { extra = { chips = 0, chip_gain = 15, food = 2 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {card.ability.extra.food}
		}
	end,

calculate = function(self, card, context)
	local food_card = nil
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i] == card then
			food_card = G.jokers.cards[i + 1]
			break
		end
	end

	if food_card then
		local eval = function()
			return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES
		end
		juice_card_until(food_card, eval, true)
	end

	if context.setting_blind and (#G.jokers.cards + G.GAME.joker_buffer) < G.jokers.config.card_limit then
		card.ability.extra.food = card.ability.extra.food - 1
		play_sound('mvan_hunger', 1, 0.55)

		return {
			message = "Starving!",
			colour = G.C.RED,
		}
	end

	if context.after and food_card then
    G.E_MANAGER:add_event(Event({
        func = (function()
            play_sound('mvan_chomp', 1, 0.55)
            food_card:start_dissolve({ G.C.RED }, nil, 1.6)
            card.ability.extra.food = card.ability.extra.food + 1
            return true
        end)
    }))
    if card.ability.extra.food > 3 then
        G.STATE = G.STATES.GAME_OVER
        G.STATE_COMPLETE = false
        return {
            message = "Overfed!",
            colour = G.C.RED,
        }
    end

    return {
        message = "Devoured!",
    }
end

	if card.ability.extra.food < 1 then
		local eval = function()
			return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES
		end
		juice_card_until(card, eval, true)

		if card.ability.extra.food < 0 then
			play_sound('mvan_ah', 1, 0.55)
			G.STATE = G.STATES.GAME_OVER
			G.STATE_COMPLETE = false
			return {
				message = "Starved!",
				colour = G.C.RED,
			}
		end
	end
end

}




SMODS.Seal {
	name = "sussy-seal",
	key = "sussy_seal",
	badge_colour = HEX("b2112a"),
	atlas = "ModdedVanilla",
	pos = {x=5, y=1},

	config = {
		mult = 5, chips = 20, money = 1, x_mult = 1.5
	},
	loc_txt = {
		-- Badge name (displayed on card description when seal is applied)
		label = 'Sussy Seal',
		-- Tooltip description
		name = 'Sussy Seal',
		text = {
			'When Hand is Played',
			'1 in 8 chance to become {C:red}Useless {} this card'
		}
	},
	loc_vars = function(self, info_queue)
		return { vars = {self.config.mult, self.config.chips, self.config.money, self.config.x_mult, } }
	end,


	-- self - this seal prototype
	-- card - card this seal is applied to
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play then
			if pseudorandom('LETSGOGAMBLING') < G.GAME.probabilities.normal / 8 then
				card:set_seal('mvan_useless_seal', true)
			end
		end
	end
}


SMODS.Consumable {
    set = "Tarot",
    key = "bacon",
    loc_vars = function(self, info_queue, card)
        -- Handle creating a tooltip with seal args.
        info_queue[#info_queue+1] = G.P_SEALS[(card.ability or self.config).extra]
        -- Description vars
        return {vars = {(card.ability or self.config).max_highlighted}}
    end,
    loc_txt = {
        name = 'Unlimited Bacon',
        text = {
			"but no more games?"
        }
    },
    cost = 4,
    atlas = "ModdedVanilla",
    pos = {x=2, y=1},

use = function(self, card, area, copier)
    play_sound('timpani')


    for n = 1, 60 do
    local delay = math.max(0.05, 0.4 - n * 0.01)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = delay,
        func = function()
			SMODS.add_card{key = "c_mvan_bacon"}
            return true
        end
    }))end


    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()

            card:juice_up(0.3, 0.5)

			error("Bacon = Infinity, Ruh Roh",0)
			return true
        end
    }))

    delay(30 * 0.4 + 0.2)
end,



    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}


SMODS.Atlas {
	key = "wipbanana",
	path = "wipbanana.png",
	px = 71,
	py = 95
}

SMODS.Suit {
   key = "banana_suit",
   card_key = "S",
   pos = {y = 0},
   ui_pos = {x=0, y=0},
   lc_atlas = "wipbanana",
   lc_ui_atlas = "wipbanana",
   hc_atlas = "wipbanana",
   hc_ui_atlas = "wipbanana",
   in_pool = true
}



SMODS.Sound{
	key = 'splosh',
	path = 'splosh.ogg'
}


SMODS.Seal {
	name = "goop-seal",
	key = "goop_seal",
	badge_colour = HEX("b2112a"),
	atlas = "ModdedVanilla",
	pos = {x=3, y=1},
	loc_txt = {
		-- Badge name (displayed on card description when seal is applied)
		label = 'Goop Seal',
		-- Tooltip description
		name = 'Goop Seal',
		text = {
			'Covers the Suit and Rank',
			'but gives {C:red,s:1.1}+#1#{} Mult'
		}
	},
    config = { mult = 4 },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.mult } }
    end,
}


SMODS.Joker {
	-- How the code refers to the joker.
	key = 'paint',
	-- loc_text is the actual name and description that show in-game for the card.
	loc_txt = {
		name = 'Painted Joker',
		text = {
			"test"
		}
	},
	--[[
		Config sets all the variables for your card, you want to put all numbers here.
		This is really useful for scaling numbers, but should be done with static numbers -
		If you want to change the static value, you'd only change this number, instead
		of going through all your code to change each instance individually.
		]]
	config = { extra = { chips = 0, chip_gain = 15 } },
	-- loc_vars gives your loc_text variables to work with, in the format of #n#, n being the variable in order.
	-- #1# is the first variable in vars, #2# the second, #3# the third, and so on.
	-- It's also where you'd add to the info_queue, which is where things like the negative tooltip are.
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,
	-- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
	rarity = 1,
	-- Which atlas key to pull from.
	atlas = 'ModdedVanilla',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 0, y = 0 },
	-- Cost of card in shop.
	cost = 2,
	-- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
	calculate = function(self, card, context)

        if context.before and context.main_eval and not context.blueprint then

			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.03, func = function(i,v)
				for i,v in ipairs(context.scoring_hand) do
					v:flip()
				end
				return true
			end}))

			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.03, func = function(i,v)
				for i,v in ipairs(context.scoring_hand) do
					v:set_seal('mvan_goop_seal', true)
					play_sound('mvan_splosh', 1, 0.55)
					v:juice_up()
				end
				return true
			end}))

			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.03, func = function(i,v)
				for i,v in ipairs(context.scoring_hand) do
					v:flip()
				end
				return true
			end}))

		end
	end
}


SMODS.Enhancement {
    key = 'repeat',

    pos = { x = 5, y = 1 },
    loc_txt = {
        name = "Repeat",
        text = {
            "Triggers {C:attention}#1#{} extra times"
        }
    },
    config = { extra = { retriggers = 4 } },

    calculate = function(self, card, context)
        if context.repetition then
            local retriggers = (card.ability.extra and card.ability.extra.retriggers) or 0
            return {
                repetitions = retriggers
            }
        end
        return nil
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.retriggers } }
    end,


}



--[[ This is called a hook. It's a less intrusive way of running your code when base game functions
	get called than lovely injections. It works by saving the base game function, local igo, then
	overwriting the current function with your own. You then run the saved function, igo, to make
	the function do everything it was previously already doing, and then you add your code in, so
	that it runs either before or after the rest of the function gets used.
							
	This function hooks into Game:init_game_object in order to create the custom
	G.GAME.current_round.castle2_card variable that the above joker uses whenever a run starts.--]]
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.castle2_card = { suit = 'Spades' }
	return ret
end



-- This is a part 2 of the above thing, to make the custom G.GAME variable change every round.
function SMODS.current_mod.reset_game_globals(run_start)
	-- The suit changes every round, so we use reset_game_globals to choose a suit.
	G.GAME.current_round.castle2_card = { suit = 'Spades' }
	local valid_castle_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then -- Abstracted enhancement check for jokers being able to give cards additional enhancements
			valid_castle_cards[#valid_castle_cards + 1] = v
		end
	end
	if valid_castle_cards[1] then
		local castle_card = pseudorandom_element(valid_castle_cards, pseudoseed('2cas' .. G.GAME.round_resets.ante))
		G.GAME.current_round.castle2_card.suit = castle_card.base.suit
	end
end

-- TODO:
-- Have people proofread, make sure my overly long way of writing is actually legible or cut down to make sure it's legible.


----------------------------------------------
------------MOD CODE END----------------------
