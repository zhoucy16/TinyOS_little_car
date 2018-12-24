#ifndef CARMSG_H
#define CARMSG_H 

#define MAXSPEED 600
#define MINSPEED 200
#define MIDSPEED (MINSPEED + MAXSPEED) / 2
#define MAXANGLE 5000
#define MINANGLE 1800
#define MIDANGLE (MINANGLE + MAXANGLE) / 2
#define TIMER_PERIOD_MILLI 150
#define TIMER_PERIOD_AUTO  1500
#define TIMER_PERIOD_RESET 500

typedef nx_struct carMsg {
	nx_uint16_t nodeid;
	nx_uint16_t type;
	nx_uint16_t action;
	nx_uint16_t data;
} carMsg;

typedef nx_struct serialMsg {
	nx_uint16_t pinA;
	nx_uint16_t pinB;
	nx_uint16_t pinC;
	nx_uint16_t pinD;	
	nx_uint16_t pinE;
	nx_uint16_t pinF;
} serialMsg;

enum {
	AM_radio = 6,
	AM_carMsg = 7,
	AM_serialMsg = 8
};

#endif