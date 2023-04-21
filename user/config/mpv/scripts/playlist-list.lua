-- adding the source directory to the package path and loading the module
package.path = mp.command_native({
    "expand-path", (mp.get_opt("scroll_list-directory") or "~~/scripts")
}) .. "/?.lua;" .. package.path
local list = require "scroll-list"

-- modifying the list settings
list.header = "Playlist"

-- jump to the selected video
local function open_video()
    if list.list[list.selected] then
        mp.set_property_number('playlist-pos', list.selected - 1)
    end
end

-- dynamic keybinds to bind when the list is open
list.keybinds = {
    {'j', 'scroll_down', function() list:scroll_down() end, {repeatable = true}},
    {'k', 'scroll_up', function() list:scroll_up() end, {repeatable = true}},
    {'l', 'open_chapter', open_video, {}},
    {'q', 'close_browser', function() list:close() end, {}}
}

function os.capture(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

function observe_change(_, current)
    list.list = {}
    local playlist_length = mp.get_property_number('playlist-count', 0)
    if playlist_length < 2 then return end

    local playlist_current = mp.get_property_number('playlist-pos', 0)
    local playlist = mp.get_property_native('playlist')

    for i = 1, #playlist do
        local item = {}

        if (i - 1 == playlist_current) then
            -- color_13
            item.style = [[{\c&H8bcbeb&}]]
        end

        local title = i .. '.'
        if (playlist[i].title ~= nil) then
            title = title .. ' ' .. playlist[i].title
        end

        item.ass = list.ass_escape(title)
        list.list[i] = item
    end
    list:update()
end

mp.observe_property('playlist-count', 'number', observe_change)
mp.observe_property('playlist-pos', 'number', observe_change)
mp.observe_property('playlist-pos-1', 'number', observe_change)

mp.add_key_binding("P", "toggle-playlist-browser", function() list:toggle() end)
