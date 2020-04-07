-- This replicates books if you have a written book and paper
minetest.register_node(
    "bookpress:copy",
    {
        description = "Printing press",
        tiles = {
            "bookpress_bottom.png", -- y+
            "bookpress_bottom.png", -- y-
            "bookpress_right.png", -- x+
            "bookpress_left.png", -- x-
            "bookpress_back.png", -- z+
            "bookpress_front.png" -- z-
        },
        is_ground_content = true,
        groups = {choppy = 2},
        on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            if (itemstack:get_name() == "default:book_written") then -- Don't want to copy anything other than books
                local inv = player:get_inventory()

                if (inv:contains_item("main", "default:paper 3")) then --You need paper -- Give book copy, take paper and send message
                    inv:add_item("main", itemstack:peek_item(1))
                    inv:remove_item("main", "default:paper 3")
                    minetest.chat_send_player(player:get_player_name(), "The book is copied ")
                     --Plays a sound at the nodes position
                     printpos = pos
                        minetest.sound_play("press", {
                            pos = {x=printpos.x, y=printpos.y, z=printpos.z},
	                        max_hear_distance = 20,
	                        gain = 8.0,
                         })
                else
                    minetest.chat_send_player(
                        player:get_player_name(),
                        "You need three sheets of paper to copy the book"
                    )
                end --End if statement to check for paper
            else -- You need a default:book_written to copy
                minetest.chat_send_player(player:get_player_name(), "You need a written book to copy")
            end --end of if statement checking for book
        end -- end of on_rightclick
    }
)

-- Recipe for the bookpress
minetest.register_craft({
    type = "shaped", 
    output = "bookpress:copy",
    recipe = {
        {"group:wood", "group:wood", "group:wood",},
        {"group:wood", "default:copper_ingot", "group:wood",},
        {"group:wood", "default:copper_ingot", "group:wood",},
    }
})
