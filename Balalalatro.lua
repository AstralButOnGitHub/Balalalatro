


-- Lowkey I got github copilot to do this.
-- I'm too stupid for this.
SMODS.current_mod.extra_tabs = function()

	local text_scale = 0.6
    return {
        {
            label = G.localization.misc.dictionary.b_credits,
            tab_definition_function = function()
                return {
                    n = G.UIT.ROOT,
                    config = {r = 0.1, minw = 4, align = "tm", padding = 0.2, colour = G.C.BLACK},
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {align = "cm", padding = 0.05},
                            nodes = {
                                {n = G.UIT.T, config = {text = G.localization.misc.dictionary.b_credits, scale = text_scale, colour = G.C.ORANGE, shadow = true}},
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = {
                                align = "cm",
                                padding = 0.1,
                                outline_colour = G.C.JOKER_GREY,
                                r = 0.1,
                                outline = 1,
                                minw = 6,
                                minh = 4,
                            },
                            nodes = {
                                {
                                    n = G.UIT.R,
                                    config = {align = "tm", padding = 0},
                                    nodes = {
                                        {
                                            n = G.UIT.C,
                                            config = {align = "tl", padding = 0.05, minw = 2.0},
                                            nodes = {
                                                {
                                                    n = G.UIT.R,
                                                    config = {align = "cm", padding = 0},
                                                    nodes = {
                                                        {n = G.UIT.T, config = {text = 'Lead Dev and Artist: ', scale = text_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                                                        {n = G.UIT.T, config = {text = '"Astral"', scale = text_scale, colour = G.C.ORANGE, shadow = true}},
                                                    }
                                                },
                                                {
                                                    n = G.UIT.R,
                                                    config = {align = "cm", padding = 0},
                                                    nodes = {
                                                        {n = G.UIT.T, config = {text = 'Smudged Joker Art: ', scale = text_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                                                        {n = G.UIT.T, config = {text = '"Astro :3"', scale = text_scale, colour = G.C.ORANGE, shadow = true}},
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            end
        }
    }
end


SMODS.Atlas {
	key = "Jokers",
	path = {
		['default'] = 'Jokers.png'
	},
	px = 71,
	py = 95
}
SMODS.Atlas({
	key = "modicon",
	path = "modicon.png",
	px = 32,
	py = 32
})

-- Why I have to define this I have no clue!
SMODS.current_mod.optional_features = {
	retrigger_joker = true
}



SMODS.Sound{
	key = 'bad_seal',
	path = 'bad_seal.ogg'
}
SMODS.Sound {
	key = 'music69',
	path = 'music69.ogg',
	pitch = 1.0,
	volume = 0.6,
}
SMODS.Sound{
	key = 'boom',
	path = 'boom.ogg'
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
SMODS.Sound{
	key = 'splosh',
	path = 'splosh.ogg'
}

-- Testing Stuff
local sounds = {'1', '2', '3', '4', 'five'}

for _, sound in ipairs(sounds) do
	SMODS.Sound{
		key = sound,
		path = 'sounds/' .. sound .. '.ogg'
	}
end




SMODS.Seal {
	name = "useless-seal",
	key = "useless_seal",
	badge_colour = HEX("b2112a"),
	atlas = "Jokers",
	pos = {x=0, y=3},

	config = {
		mult = 5, chips = 20, money = 1, x_mult = 1.5
	},
	loc_txt = {
		label = 'Useless Seal',
		name = 'Useless Seal',
		text = {
			'{C:red}Debuffs{} this card'
		}
	},
	loc_vars = function(self, info_queue)
		return { vars = {self.config.mult, self.config.chips, self.config.money, self.config.x_mult, } }
	end,


	calculate = function(self, card, context)
		card:set_debuff(true)
	end,
}

SMODS.Shader{
	key = "saturate",
	path = "saturate.fs",
}

SMODS.Edition {
	key = 'saturated',
	shader = 'balalalatro_saturate',
	prefix_config = {
		shader = false
	},
	loc_txt = {
		label = 'Saturated',
		name = 'Saturated',
		text = {
			'I dunno'
		}
	},
	config = { mult = 10 },
	in_shop = true,
	weight = 14,
	extra_cost = 3,
	sound = { sound = "holo1", per = 1.2 * 1.58, vol = 0.4 },
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
	no_collection = true,
	in_pool = function(self) return false end,
	config = { extra = { chips = 0, chip_gain = 15 } },
	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 0, y = 0 },
	cost = 5,
	blueprint_compat = false,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,
	calculate = function(self, card, context)

		if context.main_eval and context.after then

			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.03, func = function(i,v)
				for i,v in ipairs(context.scoring_hand) do
					v:flip()
				end
				return true
			end}))

			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.03, func = function(i,v)
				for i,v in ipairs(context.scoring_hand) do
					v:set_seal('balalalatro_useless_seal', true)
					play_sound('balalalatro_bad_seal', 1, 0.55)
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

SMODS.Joker {
	key = '1-5th',
	loc_txt = {
		name = '1/5th Joker',
		text = {
			"{X:mult,C:white} X#1# {} Mult for every card",
			"that isn't played"
		}
	},
	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 1, y = 0 },
	pixel_size = { w = 33, h = 45 },
	cost = 5,
	config = {
		extra = { xmult = 2 },
	},
	blueprint_compat = true,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local played = 0
			if G.play.cards then
				played = #G.play.cards
			end

			local unplayed = 0
			unplayed = math.max(0, 5 - played)
			local final_mult = 0
			 final_mult= unplayed * 2
			if final_mult < 1 then
				final_mult = 2
			end
			return {
				xmult = final_mult
			}
		end
	end


}




local replacements = {
	"PREFIX_boom", "PREFIX_example", "PREFIX_third_one",
}

SMODS.Joker {
	key = 'dwayne_egg',
	loc_txt = {
		name = 'Dwayne The Egg Johnson',
		text = {
			"After {E:2,C:attention}#1#{} more hand(s)",
			"Something will happen"
		}
	},

	config = { extra = { hands = 3, } },
	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 2, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands } }
	end,
	calculate = function(self, card, context)
		if context.after then
			--card.juice_up()
			card.ability.extra.hands = card.ability.extra.hands - 1
		end


		
		if card.ability.extra.hands < 1 then
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.03, func = function(i,v)
				play_sound('balalalatro_boom', 1, 0.55)
				SMODS.destroy_cards(card)
				SMODS.add_card {key = 'j_balalalatro_dwayne_egg_after', edition = card.edition, stickers = { 'eternal','pinned' } }
				return {
					message = "Egg.",
					colour = G.C.RED
				}
			end}))
		end


	end
}

SMODS.Joker {
	key = 'dwayne_egg_after',
	loc_txt = {
		name = 'Dwayne The Egg Johnson',
		text = {
			"EGG."
		}
	},
	no_collection = true,
	in_pool = function(self) return false end,

	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 3, y = 0 },
	cost = 5,

	config = { extra = { } },
	calculate = function(self, card, context)
	end
}



SMODS.Joker {
	key = 'wide',
	loc_txt = {
		name = 'Wide Joker',
		text = {
			"{X:mult,C:white} X#1# {} Mult if played hand contains more than 3 cards"
		}
	},
	display_size = { w = 142, h = 95 },
--	pixel_size = { w = 142, h = 95 },
	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 4, y = 0 },
	cost = 5,
	blueprint_compat = true,

    config = { extra = { x_mult = 4, size = 3 } },
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.size } }
    end,
	calculate = function(self, card, context)
        if context.joker_main and #context.full_hand > card.ability.extra.size then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
    end
}

SMODS.Joker {
	key = 'astral',
	loc_txt = {
		name = 'Astral Joker',
		text = {
			"Retriggers all {E:2,C:attention}Jokers{} twice",
			"but permanently doubles the {E:2,C:red}Winning Ante{}"
		}
	},

	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 5, y = 0 },
	cost = 5,
	blueprint_compat = true,

	config = { extra = { x_mult = 4, has_anted = false } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context)

		if context.retrigger_joker_check then
			return {
				repetitions = 2
			}
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		if G.GAME.win_ante then
			G.GAME.win_ante = G.GAME.win_ante + 8
		end
	end
}


SMODS.Joker {
	key = 'scopophobia',
	loc_txt = {
		name = 'Scopophobia',
		text = {
			"Gains {X:mult,C:white} X#2# {} Mult",
			"per scored {C:attention}number card {C:inactive}(or ace)",
			"Loses {X:mult,C:white} X#3# {} Mult",
			"per scored {C:attention}face card{}",
			"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
		}
	},
	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 15, y = 11 },
	cost = 5,
	blueprint_compat = true,

	config = { extra = { Xmult = 1, Xmult_mod1 = 0.1, Xmult_mod5 = 0.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_mod1, card.ability.extra.Xmult_mod5 } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_face() then
				card.ability.extra.Xmult = math.max(1, card.ability.extra.Xmult - card.ability.extra.Xmult_mod5)

				return {
					message = localize {
						type = 'variable',
						key = 'a_xmult',
						vars = { card.ability.extra.Xmult }
					}
				}
			else
				card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod1

				return {
					message = localize {
						type = 'variable',
						key = 'a_xmult',
						vars = { card.ability.extra.Xmult }
					}
				}
			end
		end

		if context.joker_main then
			return {
				Xmult = card.ability.extra.Xmult
			}
		end
	end
}

function StartsWith(str, start)
	return string.sub(str, 1, #start) == start
end

function getResourceWithPrefix(s)
	local results = {}
	for k, v in pairs(G.P_CENTERS) do
		if StartsWith(k, s) then
			print(k)
			table.insert(results, k)
		end
	end
	return results
end

function getBalalalatro()
	print("Getting a random fox joker...")
	local allFoxJokers = getResourceWithPrefix("j_balalalatro")
	print("Received list of " .. #allFoxJokers)

	if #allFoxJokers == 0 then
		print("No Balalalatro jokers found!")
		return nil
	end

	local randomJoker = allFoxJokers[math.random(#allFoxJokers)]
	print("Random joker selected: " .. randomJoker)
	return randomJoker
end

SMODS.Booster {
	key = "astral_pack",
	loc_txt = {
		name = "Astral Pack",
		group_name = "Astral Pack",
		text = {
			"Choose {C:attention}#1#{} of up to",
			"{C:attention}#2# {V:1}Balalalatro{} cards to"
		}
	},
	config = { extra = 3, choose = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose, card.ability.extra, colours = {HEX("8ea4b3")} } }
	end,
	cost = 4,
	atlas = "Jokers",
	weight = 1.5,
	pos = { x = 7, y = 1 },
	draw_hand = false,
	kind = "Joker",
	create_card = function(self, card)
		local balalalatro = getBalalalatro()
		print(balalalatro)
		local getCard = create_card("Joker", G.pack_cards, nil, nil, true, true, balalalatro, "Fox")
		sendInfoMessage("creating cards for this pack", self.key)

		return getCard
	end,
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, HEX("ea1f1f"))
		ease_background_colour({ new_colour = HEX('27a4f7'), special_colour = HEX("ea1f1f"), contrast = 2 })
	end
}

SMODS.Language{
	key = 'test',
	label = 'test.lua'
}

SMODS.Joker {
	key = 'british',
	loc_txt = {
		name = 'Br*tish Joker',
		text = {
			"Oi Tea And Crumpets Innit?",
			"DO NOT USE THIS CARD, IT BREAKS THE GAME."
		}
	},

	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 6, y = 0 },
	cost = 5,

	config = { extra = { x_mult = 4, size = 3 } },
	loc_vars = function(self, info_queue, card)

		return {
			vars = {
				card.ability.extra.x_mult, card.ability.extra.size
			}
		}
	end,
	calculate = function(self, card, context)

		G:set_language()
		init_localization()
		G.SETTINGS.language = "fr"
		G.SETTINGS.real_language = "fr"
		init_localization()
		G:set_language()
	end
}






SMODS.Joker {
	key = 'corrupted',
	loc_txt = {
		name = 'Corrupted Joker',
		text = {
			"ERROR: \"Unexpected Error\""
		}
	},
	no_collection = true,
	in_pool = function(self) return false end,

	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 7, y = 0 },
	cost = 5,
	blueprint_compat = true,

	config = { extra = { x_mult = 69, odds = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.x_mult, card.ability.extra.size } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if pseudorandom('xmpl_gambler') < G.GAME.probabilities.normal / card.ability.extra.odds then
				return {
					x_mult = card.ability.extra.x_mult
				}
			else
				error("ERROR",100)
			end
		end
	end



}



SMODS.Joker {
	key = 'smudged',
	loc_txt = {
		name = 'Smudged Joker',
		text = {
			"This Joker gains",
			"{X:mult,C:white} X#1# {} Mult every time",
			"a {C:attention}face card{} is scored",
			"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
		},
	},

	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 8, y = 0 },
	cost = 5,
	blueprint_compat = true,

	config = { extra = { Xmult = 1, Xmult_mod = 0.1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_face() then
				card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod

				return {
					message = localize {
						type = 'variable',
						key = 'a_xmult',
						vars = { card.ability.extra.Xmult }
					}
				}
			end
		end

		if context.joker_main then
			return {
				Xmult = card.ability.extra.Xmult
			}
		end
	end

}










SMODS.Joker {
	key = 'nuclear',
	loc_txt = {
		name = 'Nuclear Joker',
		text = {
			"When {C:attention}least played poker hand{} is played,",
			"Vaporizes adjacent {C:attention}Jokers{} ({C:purple}Eternals{} included)",
			"If not, {C:mult}+#1#{} Mult"
		}
	},


	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 9, y = 0 },
	cost = 5,

    config = { extra = { mult = 20 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
calculate = function(self, card, context)
    if context.before and context.main_eval and not context.blueprint then
        local scoring_name = context.scoring_name
        local scoring_played = (G.GAME.hands[scoring_name].played or 0) - 1

        local least_played = math.huge
        local tied_least = {}

        for k, v in pairs(G.GAME.hands) do
            if v.visible then
                local played = v.played or 0
                if k == scoring_name then played = scoring_played end

                if played < least_played then
                    least_played = played
                    tied_least = {k}
                elseif played == least_played then
                    table.insert(tied_least, k)
                end
            end
        end

        G.GAME.current_round.least_played_poker_hands = tied_least

        local is_least = false
        for _, name in ipairs(tied_least) do
            if name == scoring_name then
                is_least = true
                break
            end
        end

        local l_joker, r_joker = nil, nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                if i > 1 then l_joker = G.jokers.cards[i - 1] end
                if i < #G.jokers.cards then r_joker = G.jokers.cards[i + 1] end
                break
            end
        end

        if is_least then
            local destroyed = false

            if l_joker then
                SMODS.destroy_cards(l_joker)
                destroyed = true
            end
            if r_joker then
                SMODS.destroy_cards(r_joker)
                destroyed = true
            end

            if destroyed then
                play_sound('balalalatro_ah', 1, 0.55)
                return {
                    message = "Boom! Neighboring Joker(s) Destroyed!"
                }
            else
                return {
                    message = "No Neighboring Jokers to Destroy!"
                }
            end
        end
		return {

		}
    end
end






}











SMODS.Joker {
	key = 'cat',
	loc_txt = {
		name = 'THE CAT',
		text = {
    		"Consumes the {E:2,C:attention}Joker{} to its right",
    		"after a hand is played,",
			"gaining {E:2,C:attention}+1 Food{} per {E:2,C:attention}Joker{} consumed.",
			"Loses {E:2,C:attention}1 Food{} when a Boss Blind is defeated.",
			"You {S:1.1,C:red,E:1}lose the run{} if it runs out of {E:2,C:attention}Food{}.",
			"You also {S:1.1,C:red,E:1}lose the run{} if it has too much {E:2,C:attention}Food{}.",
			"{E:2,C:attention}Current Food: #1#{}",
		}
	},
	rarity = 1,
	no_collection = true,
	in_pool = function(self) return false end,
	atlas = 'Jokers',
	pos = { x = 10, y = 0 },
	cost = 5,
	config = { extra = { chips = 0, chip_gain = 15, food = 2 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {card.ability.extra.food}
		}
	end,

calculate = function(self, card, context)
	local food_card = nil
	if G.jokers then
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
			play_sound('balalalatro_hunger', 1, 0.55)

			return {
				message = "Starving!",
				colour = G.C.RED,
			}
		end

		if context.after and food_card then
			G.E_MANAGER:add_event(Event({
				func = (function()
					play_sound('balalalatro_chomp', 1, 0.55)
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
				play_sound('balalalatro_ah', 1, 0.55)
				G.STATE = G.STATES.GAME_OVER
				G.STATE_COMPLETE = false
				return {
					message = "Starved!",
					colour = G.C.RED,
				}
			end
		end
	end
end

}





SMODS.Seal {
	name = "sussy-seal",
	key = "sussy_seal",
	badge_colour = HEX("b2112a"),
	atlas = "Jokers",
	pos = {x=1, y=3},

	config = {
		mult = 5, chips = 20, money = 1, x_mult = 1.5
	},
	loc_txt = {
		label = 'Sussy Seal',
		name = 'Sussy Seal',
		text = {
			'When Hand is Played',
			'1 in 8 chance for this card to become {C:red}Useless{}'
		}
	},
	loc_vars = function(self, info_queue)
		return { vars = {self.config.mult, self.config.chips, self.config.money, self.config.x_mult, } }
	end,



	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play then
			if pseudorandom('LETSGOGAMBLING') < G.GAME.probabilities.normal / 8 then
				card:set_seal('balalalatro_useless_seal', true)
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
	atlas = "Jokers",
	pos = {x=1, y=1},

	use = function(self, card, area, copier)


		for n = 1, 60 do
			local delay = math.max(0.05, 0.4 - n * 0.01)
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = delay,
				func = function()
					SMODS.add_card{key = "c_balalalatro_bacon"}
					card:juice_up(0.3, 0.5)

					play_sound('timpani')

					return true
				end
			}))end


		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()


				error("Bacon = Infinity, Ruh Roh",0)
				return true
			end
		}))

		delay(30 * 0.4 + 0.2)
	end,



	can_use = function(self, card)
		return true
	end
}

SMODS.Consumable {
	set = "Tarot",
	key = "wheel_of_jimbo",
	loc_txt = {
		name = 'Wheel Of Jimbo',
		text = {
			"Take a spin!",
			"Nothing could go wrong!!"
		}
	},
	cost = 4,
	atlas = "Jokers",
	pos = {x=2, y=1},

	use = function(self, card, area, copier)
		local functions = {
			-- GOOD OPTIONS

			function()
				print("Give $10")
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						play_sound('timpani')
						card:juice_up(0.3, 0.5)
						ease_dollars(G.GAME.dollars, true)
						G.GAME.dollars = G.GAME.dollars + 10
						return true
					end
				}))
				delay(0.6)
			end,
			function()
				print("lower Winning ante by 1")
			end,
			function()
				print("4 random cards get an enhancement")
			end,



			-- BAD OPTIONS
			--insert
		}

		local chosen = functions[math.random(1, #functions)]
		chosen()

	end,



	can_use = function(self, card)
		return true
	end
}





--SMODS.Consumable {
--	set = "Spectral",
--	key = "steal",
--	loc_vars = function(self, info_queue, card)
--		info_queue[#info_queue+1] = G.P_SEALS[(card.ability or self.config).extra]
--		return {vars = {(card.ability or self.config).max_highlighted}}
--	end,
--	loc_txt = {
--		name = 'Steal',
--		text = {
--			"\"damn daniel back at it again with the white windowless vans.\""
--		}
--	},
--	cost = 4,
--	atlas = "ModdedVanilla",
--	pos = {x=12, y=2},
--
--	use = function(self, card, area, copier)
--		play_sound('timpani')
--
--
--		for n = 1, 60 do
--			local delay = math.max(0.05, 0.4 - n * 0.01)
--			G.E_MANAGER:add_event(Event({
--				trigger = 'after',
--				delay = delay,
--				func = function()
--					SMODS.add_card{key = "c_mvan_bacon"}
--					return true
--				end
--			}))end
--
--
--		G.E_MANAGER:add_event(Event({
--			trigger = 'after',
--			delay = 0.4,
--			func = function()
--
--				card:juice_up(0.3, 0.5)
--
--				error("Bacon = Infinity, Ruh Roh",0)
--				return true
--			end
--		}))
--
--		delay(30 * 0.4 + 0.2)
--	end,
--
--
--
--	can_use = function(self, card)
--		return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
--	end
--}

SMODS.Enhancement {
	name = "goop",
	key = "goop",
	badge_colour = HEX("b2112a"),
	atlas = "Jokers",
	pos = {x=0, y=4},
	loc_txt = {
		label = 'Goop\'ed Card',
		name = 'Goop\'ed Card',
		text = {
			'Covers the Suit and Rank',
			'but Retriggers this',
			'card {C:attention}#1#{} time',

		}
	},
	replace_base_card = true,
	no_rank = true,
	no_suit = true,

	config = { extra = { retriggers = 1 } },

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

SMODS.Joker {
	key = 'graffiti',
	loc_txt = {
		name = 'Graffiti Joker',
		text = {
			"All played {C:attention}cards{}",
			"become {C:attention}Goop'ed{} cards",
			"when scored",
		}
	},
	rarity = 1,
	atlas = 'Jokers',
	pos = { x = 14, y = 0 },
	cost = 2,
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
					v:set_ability('m_balalalatro_goop', nil, true)
					play_sound('balalalatro_splosh', 1, 0.55)
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

-- sketched (this is for me searching sketched instead of etched because I'm stupid.)
SMODS.Joker {
	key = "etched",
	loc_txt = {
		name = "Etched Joker",
		text = {
			"Copies the ability",
			"of leftmost or",
			"rightmost {C:attention}Joker{}.",
			"{s:0.8}Direction switches after each hand.{}",
			"{C:inactive}(Currently {C:attention}#2#{C:inactive})"
		}
	},
	blueprint_compat = false,
	atlas = "Jokers",
	pos = { x = 12, y = 0 },
	config = { extra = { direction = "Leftmost" } },

	loc_vars = function(self, info_queue, card)
		local direction = card.ability.extra.direction or "Leftmost"
		local target_name = "None"
		local compatible = false
		local other_joker = nil

		if G.jokers then
			local jokers = G.jokers.cards

			local target = (direction == "Leftmost") and jokers[1] or jokers[#jokers]
			target_name = target and target.ability.name or "None"

			for i = 1, #jokers do
				if jokers[i] == card then
					other_joker = (direction == "Leftmost") and jokers[1] or jokers[#jokers]
					break
				end
			end

			compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat or false
		end

		local main_end = (card.area and card.area == G.jokers) and {
			{
				n = G.UIT.C,
				config = { align = "bm", minh = 0.4 },
				nodes = {
					{
						n = G.UIT.C,
						config = {
							ref_table = card,
							align = "m",
							colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
							r = 0.05,
							padding = 0.06
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ',
									colour = G.C.UI.TEXT_LIGHT,
									scale = 0.32 * 0.8
								}
							},
						}
					}
				}
			}
		} or nil

		return {
			vars = { target_name, direction },
			main_end = main_end
		}
	end,

	calculate = function(self, card, context)
		local direction = card.ability.extra.direction or "Leftmost"
		if G.jokers then
			local jokers = G.jokers.cards
			local target = (direction == "Leftmost") and jokers[1] or jokers[#jokers]

			if target == card then
				target = nil
			end

				local ret
				if target then
					ret = SMODS.blueprint_effect(card, target, context)
					if ret then
						ret.colour = G.C.RED
					end
				end



				if context.after and not context.blueprint and not context.retrigger_joker then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.03, func = function(i,v)
						card.ability.extra.direction = (direction == "Leftmost") and "Rightmost" or "Leftmost"
						return {
							message = "Switch!",
						}
					end}))
				end

				return ret
			end
	end
}




SMODS.Atlas {
	key = "wipbanana",
	path = {
		['default'] = 'wipbanana.png'
	},
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "banana_ui",
	path = {
		['default'] = 'banana_ui.png'
	},
	px = 18,
	py = 18
}

SMODS.Suit {
   key = "banana_suit",
   card_key = "B",
   loc_txt = {
	   singular = 'Banan',
	   plural = 'Banans',
   },
   pos = {y = 0},
   ui_pos = {x=0, y=0},
   lc_atlas = "wipbanana",
   lc_ui_atlas = "banana_ui",
   hc_atlas = "wipbanana",
   hc_ui_atlas = "banana_ui",
   lc_colour = 'fddf00',
   hc_colour = 'fddf00',
   in_pool = function(self) return false end
}








SMODS.Challenge {
	key = 'cat_challenge',
	loc_txt = 'The Devourer',
	jokers = {
		{
			id = 'j_balalalatro_cat', eternal=true
		}
	},
	unlocked = true
}

SMODS.Challenge {
	key = 'hopeless_challenge',
	loc_txt = 'There\'s Nothing We Can Do...',
	jokers = {
		{
			id = 'j_balalalatro_useless', eternal=true
		}
	},
	unlocked = true
}

SMODS.Challenge {
	key = 'nuclear_challenge',
	loc_txt = 'Nuclear Family',
	jokers = {
		{
			id = 'j_balalalatro_nuclear', eternal=true,
		}
	},
	unlocked = true
}

SMODS.Challenge {
	key = 'error_challenge',
	loc_txt = 'ERROR: UNEXPECTED CHALLENGE',
	jokers = {
		{
			id = 'j_balalalatro_corrupted', eternal=true,
		}
	},
	unlocked = true
}

SMODS.Challenge {
	key = 'easy_challenge',
	loc_txt = 'Easy Dubz',
	jokers = {
		{ id = 'j_balalalatro_astral' }
	},
	rules = {
		modifiers = {
			{ id = "joker_slots", value = 10 },
		},
	},
	unlocked = true
}

SMODS.Challenge {
	key = 'banan_challenge',
	loc_txt = 'Banan.',
	jokers = {
		{ id = 'j_gros_michel' },
		{ id = 'j_cavendish' }
	},
	deck = {
		type = 'Challenge Deck',
		cards = {
			-- Aces
			{ s = 'balalalatro_B', r = 'A' }, { s = 'balalalatro_B', r = 'A' }, { s = 'balalalatro_B', r = 'A' }, { s = 'balalalatro_B', r = 'A' },
			-- 2s
			{ s = 'balalalatro_B', r = '2' }, { s = 'balalalatro_B', r = '2' }, { s = 'balalalatro_B', r = '2' }, { s = 'balalalatro_B', r = '2' },
			-- 3s
			{ s = 'balalalatro_B', r = '3' }, { s = 'balalalatro_B', r = '3' }, { s = 'balalalatro_B', r = '3' }, { s = 'balalalatro_B', r = '3' },
			-- 4s
			{ s = 'balalalatro_B', r = '4' }, { s = 'balalalatro_B', r = '4' }, { s = 'balalalatro_B', r = '4' }, { s = 'balalalatro_B', r = '4' },
			-- 5s
			{ s = 'balalalatro_B', r = '5' }, { s = 'balalalatro_B', r = '5' }, { s = 'balalalatro_B', r = '5' }, { s = 'balalalatro_B', r = '5' },
			-- 6s
			{ s = 'balalalatro_B', r = '6' }, { s = 'balalalatro_B', r = '6' }, { s = 'balalalatro_B', r = '6' }, { s = 'balalalatro_B', r = '6' },
			-- 7s
			{ s = 'balalalatro_B', r = '7' }, { s = 'balalalatro_B', r = '7' }, { s = 'balalalatro_B', r = '7' }, { s = 'balalalatro_B', r = '7' },
			-- 8s
			{ s = 'balalalatro_B', r = '8' }, { s = 'balalalatro_B', r = '8' }, { s = 'balalalatro_B', r = '8' }, { s = 'balalalatro_B', r = '8' },
			-- 9s
			{ s = 'balalalatro_B', r = '9' }, { s = 'balalalatro_B', r = '9' }, { s = 'balalalatro_B', r = '9' }, { s = 'balalalatro_B', r = '9' },
			-- 10s
			{ s = 'balalalatro_B', r = 'T' }, { s = 'balalalatro_B', r = 'T' }, { s = 'balalalatro_B', r = 'T' }, { s = 'balalalatro_B', r = 'T' },
			-- Jacks
			{ s = 'balalalatro_B', r = 'J' }, { s = 'balalalatro_B', r = 'J' }, { s = 'balalalatro_B', r = 'J' }, { s = 'balalalatro_B', r = 'J' },
			-- Queens
			{ s = 'balalalatro_B', r = 'Q' }, { s = 'balalalatro_B', r = 'Q' }, { s = 'balalalatro_B', r = 'Q' }, { s = 'balalalatro_B', r = 'Q' },
			-- Kings
			{ s = 'balalalatro_B', r = 'K' }, { s = 'balalalatro_B', r = 'K' }, { s = 'balalalatro_B', r = 'K' }, { s = 'balalalatro_B', r = 'K' },
		}
	},
	rules = {
		modifiers = {
			{ id = "joker_slots", value = 10 },
		},
	},
	unlocked = true
}








-- if you're reading this go outside. get a shower.