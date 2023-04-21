-- original from https://github.com/CogentRedTester/mpv-scroll-list
-- I've modified it to my own liking and wasn't sure how else to credit the author
--[[
    This script implements an interactive chapter list

    This script was written as an example for the mpv-scroll-list api
    https://github.com/CogentRedTester/mpv-scroll-list
]] local mp = require 'mp'

-- adding the source directory to the package path and loading the module
package.path = mp.command_native({
    "expand-path", (mp.get_opt("scroll_list-directory") or "~~/scripts")
}) .. "/?.lua;" .. package.path
local list = require "scroll-list"

-- modifying the list settings
list.header = "Chapters"

-- jump to the selected chapter
local function open_chapter()
    if list.list[list.selected] then
        mp.set_property_number('chapter', list.selected - 1)
    end
end

-- dynamic keybinds to bind when the list is open
list.keybinds = {
    {'j', 'scroll_down', function() list:scroll_down() end, {repeatable = true}},
    {'k', 'scroll_up', function() list:scroll_up() end, {repeatable = true}},
    {'l', 'open_chapter', open_chapter, {}},
    {'q', 'close_browser', function() list:close() end, {}}
}

-- update the list when the current chapter changes
mp.observe_property('chapter', 'number', function(_, curr_chapter)
    list.list = {}
    local chapter_list = mp.get_property_native('chapter-list', {})
    for i = 1, #chapter_list do
        local item = {}
        if (i - 1 == curr_chapter) then
            -- color_13
            item.style = [[{\c&H8bcbeb&}]]
        end

        -- Youtube returns '<Untitled Chapter 1>' for the first untitled chapter
        local title = chapter_list[i].title
        if (title == '<Untitled Chapter 1>') then title = 'Chapter 1' end

        item.ass = list.ass_escape(title)
        list.list[i] = item
    end
    list:update()
end)

mp.add_key_binding("p", "toggle-chapter-browser", function() list:toggle() end)
