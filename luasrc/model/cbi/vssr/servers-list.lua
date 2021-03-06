-- Licensed to the public under the GNU General Public License v3.
local d = require "luci.dispatcher"
local fs = require "nixio.fs"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()
local m, s, o
local vssr = "vssr"


local uci = luci.model.uci.cursor()
local server_count = 0
uci:foreach("vssr", "servers", function(s)
  server_count = server_count + 1
end)



m = Map(vssr)
m:section(SimpleSection).template  = "vssr/status"


-- [[ Servers Manage ]]--
s = m:section(TypedSection, "servers")
s.anonymous = true
s.addremove = true
s.description = string.format(translate("Server Count") ..  ": %d", server_count)
s.sortable = true
s.template = "cbi/tblsection"
s.extedit = luci.dispatcher.build_url("admin/vpn/vssr/servers/%s")
function s.create(...)
	local sid = TypedSection.create(...)
	if sid then
		luci.http.redirect(s.extedit % sid)
		return
	end
end

o = s:option(DummyValue, "type", translate("Type"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or translate("")
end

o = s:option(DummyValue, "alias", translate("Alias"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or translate("None")
end

o = s:option(DummyValue, "server", translate("Server Address"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or "?"
end

o = s:option(DummyValue, "server_port", translate("Server Port"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or "?"
end

o = s:option(DummyValue, "encrypt_method", translate("Encrypt Method"))
o.width="10%"

o = s:option(DummyValue, "protocol", translate("Protocol"))
o.width="10%"

o = s:option(DummyValue, "obfs", translate("Obfs"))
o.width="10%"
o = s:option(Flag, "switch_enable", translate("Enable Auto Switch"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or "?"
end

o = s:option(DummyValue,"server",translate("Ping Latency"))
o.template="vssr/ping1"
o.width="10%"

m:append(Template("vssr/server_list"))

return m
