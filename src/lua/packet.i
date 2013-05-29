%module packet
%{
#include <haka/packet.h>
#include <haka/packet_module.h>

void lua_pushppacket(lua_State *L, struct packet *pkt)
{
	SWIG_NewPointerObj(L, pkt, SWIGTYPE_p_packet, 0);
}
%}

%include haka/swig.i

%rename(ACCEPT) FILTER_ACCEPT;
%rename(DROP) FILTER_DROP;

enum filter_result { FILTER_ACCEPT, FILTER_DROP };

%nodefaultctor;

struct packet {
	%extend {
		%immutable;
		size_t length;
		const char *dissector;
		const char *nextDissector;

		size_t __len(void *dummy)
		{
			return packet_length($self);
		}

		int __getitem(int index)
		{
			--index;
			if (index < 0 || index >= packet_length($self)) {
				error(L"out-of-bound index");
				return 0;
			}
			return packet_data($self)[index];
		}

		void __setitem(int index, int value)
		{
			--index;
			if (index < 0 || index >= packet_length($self)) {
				error(L"out-of-bound index");
				return;
			}
			packet_data_modifiable($self)[index] = value;
		}

		%rename(drop) _drop;
		void _drop()
		{
			packet_drop($self);
		}

		%rename(accept) _accept;
		void _accept()
		{
			packet_accept($self);
		}

		struct packet *forge()
		{
			packet_accept($self);
			return NULL;
		}
	}
};

%{
size_t packet_length_get(struct packet *pkt) {
	return packet_length(pkt);
}

const char *packet_dissector_get(struct packet *pkt) {
	return "raw";
}

const char *packet_nextDissector_get(struct packet *pkt) {
	return packet_dissector(pkt);
}
%}
