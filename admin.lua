	elseif query:lower() == "select * from clientinfo" then
		fields = {{name="id",type=proxy.MYSQL_TYPE_LONG},{name="client",type=proxy.MYSQL_TYPE_STRING},{name="description",type=proxy.MYSQL_TYPE_STRING}, {name="time",type=proxy.MYSQL_TYPE_LONG}}
		--rows[#rows + 1] = { 1, proxy.global.clientinfo[1] }
		--for i = 1, #proxy.global.clientinfo do
		--	rows[#rows + 1] = {
		--		i,
		--		proxy.global.clientinfo[i]
		--	}
		for k,v in pairs(proxy.global.clientinfo) do
			rows[#rows + 1] = {
			    i,k,v,os.time()
			}
		end
