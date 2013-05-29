
require("proto-ipv4")
require("proto-tcp")

haka2.rule {
	hooks = { "ipv4-up" },
	eval = function (self, pkt)
		haka.log.debug("filter", "thread %i: filtering packet [len=%d]", haka.app.currentThread(), pkt.len)
	end
}
