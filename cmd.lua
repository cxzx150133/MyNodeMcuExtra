-- cmd.lua
local cmd ={}
-- OS Function
function info()
  local majorVer , minorVer , devVer,
        chipid   , flashid  ,
        flashsize, flashmode, flashspeed = node.info();

  print("NodeMCU "   .. majorVer.."."..minorVer.."."..devVer)
  print("chipid:"    .. chipid    )-- node.chipid()
  print("flashid:"   .. flashid   )-- node.flashid()
  print("flashsize:" .. flashsize )-- node.flashid()
  print("flashmode:" .. flashmode )-- node.flashsize()
  print("flashspeed:".. flashspeed)-- 
end

function free()
  data=node.heap()
  local l={"B","KB","MB"}
  local r=1
  while data>=1024 do
    data=data/1024
    r=r+1
  end
  print("Remaining:"..string.format("%.2f",data)..l[r])
end

function reboot()
  node.restart()
end
-- File System Function
function ls()
  local l = file.list()
  for k,v in pairs(l) do
    print("name:"..k..", size:"..v)
  end
end

function df()
  remaining,used,total=file.fsinfo()
  print("File System Info:")
  print("Total : "..total.." bytes")
  print("Used  : "..used.. " bytes")
  print("Remain: "..remaining.." bytes")
  data=tonumber(remaining)
  local l={"B","KB","MB"}
  local r=1
  while data>=1024 do
    data=data/1024
    r=r+1
  end
  print("Remaining:"..string.format("%.2f",data)..l[r])
end

function rm(filename)
  file.remove(filename)
end
function cat(filename)
  local line
  file.open(filename, "r")
  while 1 do
    line = file.readline()
    if line == nil then
      break
    end
    line = string.gsub(line, "\n", "")
    print(line)
  end
  file.close()
end
-- Web Function
function getFile(p,f)
  local strPost = "GET /"..p.."f="..f.." HTTP/1.0\r\nHost: "..'www.mcunode.com'.."\r\n\r\n"
  local sk=net.createConnection(net.TCP, 0)
  local s=0
  file.remove(f)
  file.open(f,"a")
  sk:on("connection", function(sck) sk:send(strPost) end)
  sk:on("receive",
    function(sck, res)
      local pos=string.find(res,"%c%c%c")
      if pos~=nil then
        s=1
        pos=pos+4
      else
        pos=0
      end
      if s==1 then
        file.write(res:sub(pos))
      end
      res=nil
      collectgarbage()
    end
  )
  sk:dns(host,function(conn,ip) sk:connect(80,ip) end)
  tmr.alarm(5,2000,0,function() sk:close() sk=nil strPost = nil file.close() collectgarbage() end)
end
