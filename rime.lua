-- 日期时间输入
-- 输入 rq 输出当前日期，输入 sj 输出当前时间

function demote_rare_char_filter(input, env)
  local held = {}
  for cand in input:iter() do
    if cand.text == "𧹒" then
      table.insert(held, cand)
    else
      yield(cand)
    end
  end
  for _, cand in ipairs(held) do
    yield(cand)
  end
end

function date_time_translator(input, seg)
  if input == "rq" then
    local date = os.date("%Y-%m-%d")
    local cand = Candidate("date", seg.start, seg._end, date, "日期")
    cand.quality = 100
    yield(cand)
  elseif input == "sj" then
    local time = os.date("%Y-%m-%d %H:%M:%S")
    local cand = Candidate("time", seg.start, seg._end, time, "时间")
    cand.quality = 100
    yield(cand)
  end
end

local RADICAL_LOOKUP_SHIFT_L = 0xffe1
local RADICAL_LOOKUP_PREFIX_KEYCODE = 0x7e
local KNOOP = 2
local KACCEPTED = 1

local radical_lookup_armed = false

function radical_lookup_trigger(key, env)
  local engine = env.engine
  local context = engine.context
  if key.keycode ~= RADICAL_LOOKUP_SHIFT_L then
    radical_lookup_armed = false
    return KNOOP
  end
  if key:ctrl() or key:alt() or key:super() then
    radical_lookup_armed = false
    return KNOOP
  end
  if not key:release() then
    radical_lookup_armed = true
    return KNOOP
  end
  local tap = radical_lookup_armed
  radical_lookup_armed = false
  if not tap then
    return KNOOP
  end
  if context:is_composing() or context:get_option("ascii_mode") then
    return KNOOP
  end
  engine:process_key(KeyEvent(RADICAL_LOOKUP_PREFIX_KEYCODE, 0))
  return KACCEPTED
end
