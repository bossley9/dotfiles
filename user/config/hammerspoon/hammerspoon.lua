local hyper = { 'cmd', 'alt', 'ctrl', 'shift' }

local bindings = {
  ['0'] = 'kitty',
  -- HS cannot differentiate multiple version of apps
  ['9'] = '/Applications/Google Chrome.app',
  ['3'] = 'zoom.us',
  ['2'] = 'finder',
}

for key, app in pairs(bindings) do
  --- @diagnostic disable-next-line hs is defined
  hs.hotkey.bind(hyper, key, function()
    --- @diagnostic disable-next-line hs is defined
    hs.application.launchOrFocus(app)
  end)
end
