-- 日期时间输入
-- 输入 rq 输出当前日期，输入 sj 输出当前时间

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
