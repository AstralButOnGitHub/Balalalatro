local jd_def = JokerDisplay.Definitions

jd_def["j_balalalatro_etched"] = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED },
        { text = ")" }
    },
    calc_function = function(card)
        local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
        card.joker_display_values.blueprint_compat = localize('k_incompatible')
        JokerDisplay.copy_display(card, copied_joker, copied_debuff)
        if copied_joker and copied_joker ~= card.joker_display_values.copy then
            card.children.joker_display:add_extra({
                {
                    { ref_table = "card.ability.extra", ref_value = "direction", colour = G.C.JOKER_GREY }
                }
            })
        end
        card.joker_display_values.copy = copied_joker
    end,
    get_blueprint_joker = function(card)
        local jokers = G.jokers and G.jokers.cards
        if not jokers then return nil end

        local direction = card.ability.extra.direction or "Leftmost"
        local target = (direction == "Leftmost") and jokers[1] or jokers[#jokers]


        if target == card then return nil end

        return target
    end

}

jd_def["j_balalalatro_smudged"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    }
}

jd_def["j_balalalatro_scopophobia"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    }
}

jd_def["j_balalalatro_wide"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local x_mult = 1
        local played = JokerDisplay.current_hand or {}
        local count = #played

        if count > 3 then
            x_mult = 4
        end
        card.joker_display_values.x_mult = x_mult
    end
}

jd_def["j_balalalatro_1-5th"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local played = JokerDisplay.current_hand or {}
        local played_count = #played
        local unplayed = math.max(0, 5 - played_count)

        local final_mult = unplayed * card.ability.extra.xmult
        card.joker_display_values.x_mult = final_mult
        if final_mult >= 7.5 then
            card.joker_display_values.x_mult = 1
        end
        if final_mult <= 0 then
            card.joker_display_values.x_mult = 1
        end
    end
}

jd_def["j_balalalatro_pi"] = {
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult",  colour = G.C.MULT,  retrigger_type = "mult" }
    },
    calc_function = function(card)
        local mult = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() and not scoring_card:is_face() and scoring_card:get_id() ~= 10 then
                    local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    mult = mult + card.ability.extra.mult * retriggers
                end
            end
        end
        card.joker_display_values.mult = mult
    end
}