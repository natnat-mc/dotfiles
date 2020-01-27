if arg[1] == '--help' or arg[1] == '-h' then
  local scriptpath
  do
    local fd = io.popen("realpath '" .. tostring(arg[0]) .. "'")
    scriptpath = fd:read('*l')
    fd:close()
  end
  io.write("Usage: prompt <lastexit> <cwd> <username> <hostname>\n")
  io.write("For bash: PROMPT_COMMAND='PS1=\"`moon " .. tostring(scriptpath) .. "` $? \\`pwd\\` \\`whoami\\` \\`hostname\\``\"'\n")
  io.write("For fish: function fish_prompt --description 'a powerline-like prompt for any shell'; moon " .. tostring(scriptpath) .. " $status (pwd) (whoami) (hostname); end\n")
  os.exit(0)
end
local lastexit, cwd, username, hostname, options
do
  local _obj_0 = arg
  lastexit, cwd, username, hostname, options = _obj_0[1], _obj_0[2], _obj_0[3], _obj_0[4], _obj_0[5]
end
lastexit = tonumber(lastexit)
local oneline = options and options:match('o')
local nopowerline = options and options:match('P')
local dumbterminal = options and options:match('d')
if #arg ~= 4 and #arg ~= 5 then
  io.stderr:write("Usage: prompt <lastexit> <cwd> <username> <hostname> [options]\n")
  io.stderr:write("\tprompt --help\n")
  os.exit(1)
end
local colors = {
  statusok = '228822',
  statusko = 'aa2222',
  battery = '8822aa',
  time = '5522aa',
  username = '2222aa',
  hostname = '2255aa',
  cwd = '2288aa',
  gitrepo = 'aa22aa',
  gitbranch = 'aa55aa',
  gitstatus = 'aa88aa'
}
local dumbcolors = {
  statusok = 2,
  statusko = 1,
  battery = 5,
  time = 4,
  username = 3,
  hostname = 7,
  cwd = 4,
  gitrepo = 5,
  gitbranch = 4,
  gitstatus = 2
}
local powerlineterminals = {
  ['tmux'] = true,
  ['xterm-kitty'] = true
}
local goodterminals = {
  ['xterm-kitty'] = true,
  ['tmux'] = true,
  ['linux'] = true
}
local batterypath = '/sys/class/power_supply/BAT1/capacity'
local hextable
do
  local _tbl_0 = { }
  for i = 0, 9 do
    _tbl_0[(tostring(i))] = i
  end
  hextable = _tbl_0
end
for a = 0, 5 do
  hextable[string.char(a + string.byte('a'))] = a + 10
end
local esc = tostring(string.char(0x1b)) .. "["
if not (powerlineterminals[os.getenv('TERM')]) then
  nopowerline = true
end
if not (goodterminals[os.getenv('TERM')]) then
  dumbterminal = true
end
local exec
exec = function(line)
  local a = os.execute(line)
  return a == 0 or a == true
end
local execl
execl = function(line)
  local fd = io.popen(line, 'r')
  local rst = fd:read('*l')
  fd:close()
  return rst
end
local exect
exect = function(line)
  local fd = io.popen(line, 'r')
  local lines
  do
    local _accum_0 = { }
    local _len_0 = 1
    for line in fd:lines() do
      _accum_0[_len_0] = line
      _len_0 = _len_0 + 1
    end
    lines = _accum_0
  end
  fd:close()
  return lines
end
local readl
readl = function(path)
  local fd = io.open(path, 'r')
  local rst = fd:read('*l')
  fd:close()
  return rst
end
local hextodec
hextodec = function(hex)
  local n = 0
  for i = 1, #hex do
    n = 16 * n + hextable[hex:sub(i, i)]
  end
  return n
end
local getcolor
getcolor = function(name, bg)
  if bg == nil then
    bg = false
  end
  local color = colors[name] or 'ffffff'
  return tostring(esc) .. tostring(bg and 48 or 38) .. ";2;" .. tostring(hextodec(color:sub(1, 2))) .. ";" .. tostring(hextodec(color:sub(3, 4))) .. ";" .. tostring(hextodec(color:sub(5, 6))) .. "m"
end
local getdumbcolor
getdumbcolor = function(name)
  local color = dumbcolors[name] or '7'
  return tostring(esc) .. "3" .. tostring(color) .. "m"
end
local shortenpath
shortenpath = function(path)
  if path == '/' or path == '.' then
    return path
  end
  local home = os.getenv('HOME' or "/home/" .. tostring(username))
  if (path:sub(1, #home)) == home then
    path = "~" .. tostring(path:sub(#home + 1))
  end
  local shorten
  shorten = function(e)
    if (e:sub(1, 1)) == '.' then
      return e:sub(1, 2)
    end
    return e:sub(1, 1)
  end
  local sp
  do
    local _accum_0 = { }
    local _len_0 = 1
    for e in path:gmatch('[^/]+') do
      _accum_0[_len_0] = e
      _len_0 = _len_0 + 1
    end
    sp = _accum_0
  end
  for i, e in ipairs(sp) do
    if i ~= #sp then
      sp[i] = shorten(e)
    end
  end
  return table.concat(sp, '/')
end
local render
render = function(blocks)
  if dumbterminal then
    for i, block in ipairs(blocks) do
      io.write(tostring(getdumbcolor(block.color)) .. " " .. tostring(block.text))
    end
    return io.write(tostring(esc) .. "0m ")
  else
    for i, block in ipairs(blocks) do
      io.write(tostring(getcolor(block.color, true)) .. " " .. tostring(block.text) .. " ")
      if nopowerline then
        if i == #blocks then
          io.write(tostring(esc) .. "0m ")
        else
          io.write(getcolor(blocks[i + 1]))
        end
      else
        if i == #blocks then
          io.write(tostring(esc) .. "49m" .. tostring(getcolor(block.color, false)) .. "" .. tostring(esc) .. "0m ")
        else
          io.write(tostring(getcolor(block.color, false)) .. tostring(getcolor(blocks[i + 1].color, true)) .. "" .. tostring(esc) .. "39m")
        end
      end
    end
  end
end
local blocks = { }
do
  if lastexit == 0 then
    table.insert(blocks, {
      text = 0,
      color = 'statusok'
    })
  else
    table.insert(blocks, {
      text = lastexit,
      color = 'statusko'
    })
  end
  pcall(function()
    return table.insert(blocks, {
      text = tostring(readl(batterypath)) .. "%",
      color = 'battery'
    })
  end)
  table.insert(blocks, {
    text = (os.date('%H:%M')),
    color = 'time'
  })
  table.insert(blocks, {
    text = username,
    color = 'username'
  })
  table.insert(blocks, {
    text = hostname,
    color = 'hostname'
  })
  table.insert(blocks, {
    text = (shortenpath(cwd)),
    color = 'cwd'
  })
end
if not (oneline) then
  render(blocks)
  blocks = { }
end
do
  local repo = execl('git rev-parse --git-dir 2>/dev/null')
  if repo then
    repo = shortenpath(execl("dirname '" .. tostring(repo) .. "'"))
    local branches
    do
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = (exect('git branch -l'))
      for _index_0 = 1, #_list_0 do
        local branch = _list_0[_index_0]
        _accum_0[_len_0] = {
          active = (branch:match('%*')),
          name = (branch:match('[%s*]*(.+)%s*'))
        }
        _len_0 = _len_0 + 1
      end
      branches = _accum_0
    end
    local branch = ((function()
      local _accum_0 = { }
      local _len_0 = 1
      for _index_0 = 1, #branches do
        local branch = branches[_index_0]
        if branch.active then
          _accum_0[_len_0] = branch.name
          _len_0 = _len_0 + 1
        end
      end
      return _accum_0
    end)())[1] or "no branch"
    local changes = #exect('git status --porcelain')
    if changes == 0 then
      changes = 'clean'
    elseif changes == 1 then
      changes = '1 change'
    else
      changes = changes .. ' changes'
    end
    io.write('\n')
    if not (oneline) then
      blocks = { }
    end
    if not (oneline) then
      table.insert(blocks, {
        text = repo,
        color = 'gitrepo'
      })
    end
    table.insert(blocks, {
      text = branch,
      color = 'gitbranch'
    })
    table.insert(blocks, {
      text = changes,
      color = 'gitstatus'
    })
  end
end
return render(blocks)
