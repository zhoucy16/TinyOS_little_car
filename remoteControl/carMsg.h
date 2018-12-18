#ifndef CARMSG_H
#define CARMSG_H 

typedef nx_struct carMsg {
	nx_uint16_t nodeid;
	nx_uint16_t type;
	nx_uint8_t action;
	nx_uint16_t data;
} carMsg;

enum {
	AM_carMsg = 7
};

#endif