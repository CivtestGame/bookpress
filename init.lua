-- This replicates books if you have a written book and paper
minetest.register_node(
    "bookpress:copy",
    {
        description = "Printing Press",
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
            local pname = player:get_player_name()
            -- Don't want to copy anything other than books
            if not itemstack:get_name() == "default:book_written" then
               minetest.chat_send_player(
                  pname, "Only written books can be copied."
               )
               return itemstack
            end

            local inv = player:get_inventory()
            -- You need paper, give book copy, take paper and send message
            if inv:contains_item("main", "default:paper 3") then
               player_api.give_item(player, itemstack:peek_item(1))
               inv:remove_item("main", "default:paper 3")
               minetest.chat_send_player(pname, "The book has been copied.")
               -- Play a sound at the nodes position
               local printpos = pos
               minetest.sound_play("press", {
                                      pos = {x=printpos.x, y=printpos.y, z=printpos.z},
                                      max_hear_distance = 20,
                                      gain = 8.0,
               })
            else
               minetest.chat_send_player(
                  pname,
                  "You need three sheets of paper in your hotbar to copy a book."
               )
            end
        end
    }
)

-- Recipe for the bookpress
minetest.register_craft({
    type = "shaped",
    output = "bookpress:copy",
    recipe = {
        {"group:wood", "group:wood", "group:wood",},
        {"group:wood", "group:ferrous_ingot", "group:wood",},
        {"group:wood", "group:metal_ingot", "group:wood",},
    }
})
