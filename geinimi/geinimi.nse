description = [[
Detect if Geinimi trojan is present
]]

---
-- @output
-- PORT   STATE SERVICE
-- 5432/tcp open  postgresql
-- |_geinimi: Geinimi trojan present

author = "Jaime Blasco jaime.blasco@alienvault.com"

license = "Same as Nmap--See http://nmap.org/book/man-legal.html"

categories = {"discovery", "safe"}

require "comm"
require "shortport"
local stdnse = require "stdnse"

portrule = shortport.portnumber(5432, {"tcp"})

action = function(host, port)
	local try = nmap.new_try()
	local response = try(comm.exchange(host, port, "hi,are you online?",
        	{lines=100, proto=port.protocol, timeout=5000}))
	if (response:find "yes,I'm online!") then
		return "Geinimi trojan present"
	end
end

