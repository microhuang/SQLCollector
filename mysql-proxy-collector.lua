local proto = assert(require("mysql.proto"))
local password = assert(require("mysql.password"))

local clientinfo={}


    function Split(str, delim, maxNb)
        -- Eliminate bad cases...   
        if string.find(str, delim) == nil then
            return { str }
        end
        if maxNb == nil or maxNb < 1 then
            maxNb = 0    -- No limit   
        end
        local result = {}
        local pat = "(.-)" .. delim .. "()"
        local nb = 0
        local lastPos
        for part, pos in string.gfind(str, pat) do
            nb = nb + 1
            result[nb] = part
            lastPos = pos
            if nb == maxNb then break end
        end
        -- Handle the last field   
        if nb ~= maxNb then
            result[nb + 1] = string.sub(str, lastPos)
        end
        return result
    end

function read_query(packet)
    local query = packet:sub(2)
    if string.sub(query:lower(),1,9) == "comment--" then
        --local userinfo=Split(proxy.connection.client.username,"|",2)
        --clientinfo[proxy.connection.client.src.address..":"..proxy.connection.client.src.port]={userinfo[2],os.time()}
        --print(userinfo[2])
        --print(string.sub(query:lower(),1,7))
        clientinfo[proxy.connection.client.src.name .. proxy.connection.client.dst.name]=string.sub(query,10)
        proxy.global.clientinfo=clientinfo
        proxy.response = {
                type = proxy.MYSQLD_PACKET_OK,
                resultset = {
                        fields = {{name="id",type=proxy.MYSQL_TYPE_LONG}, {name="description",type=proxy.MYSQL_TYPE_STRING}, {name="time",type=proxy.MYSQL_TYPE_LONG}},
                        rows = {{1,userinfo[2],os.time()}}
                }
        }
        return proxy.PROXY_SEND_RESULT
    end
end

function ____read_auth()
    --split tag
    --local c = proxy.connection.client
    --local s = proxy.connection.server

    local userinfo=Split(proxy.connection.client.username,"|",2)
    clientinfo[proxy.connection.client.src.address..":"..proxy.connection.client.src.port]={userinfo[2],os.time()}
    --clientinfo[userinfo[2]]=1
    --print(userinfo[2])
    proxy.global.clientinfo=clientinfo

    local protocol_41_default_capabilities = 8+512+ 32768  
                            --8 +     -- _CONNECT_WITH_DB  
                            --512 +   -- _PROTOCOL_41  
                            --32768   -- _SECURE_CONNECTION  


proxy.queries:append(1, 
        proto.to_response_packet({ username = userinfo[1], server_capabilities=protocol_41_default_capabilities})
)
return proxy.PROXY_SEND_QUERY

end

function disconnect_client()
    clientinfo[proxy.connection.client.src.name .. proxy.connection.client.dst.name]=nil
    --clientinfo[proxy.connection.client.src.address..":"..proxy.connection.client.src.port]=nil
    --print(proxy.connection.client.username)
    --print(clientinfo[proxy.connection.client.username])
    --for k,v in pairs(clientinfo) do
    --    print( k,v )
    --end
end
