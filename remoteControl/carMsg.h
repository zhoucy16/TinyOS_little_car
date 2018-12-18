#ifndef CARMSG_H
#define CARMSG_H 

typedef nx_struct carMsg {
	nx_uint16_t nodeid;
	nx_uint16_t type;
	nx_uint8_t action;
	nx_uint16_t data;
} carMsg;

typedef nx_struct serialMsg {
	nx_unit16_t pinA;
	nx_unit16_t pinB;
	nx_unit16_t pinC;
	nx_unit16_t pinD;	
	nx_unit16_t pinE;
	nx_unit16_t pinF;
}serialMsg;

enum {
	AM_carMsg = 7,
	AM_serialMsg = 8
};

#endif