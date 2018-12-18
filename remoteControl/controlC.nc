#include "carMsg.h"

#define MAXSPEED 600
#define MINSPEED 200
#define MAXANGLE 4500
#define MIDANGLE 4500
#define MINANGLE 500

moudule ControlC {
    uses interface Boot;
    uses interface Leds;
    uses interface Timer<Tmilli> as timer;
    uses interface Button;
    uses interface Read<uint16_t> as adcRead1;
	uses interface Read<uint16_t> as adcRead2;
    uses interface Packet as Packet;
    uses interface AMSend as AMSend;
    uses interface Receive as Receive;
    uses interface SplitControl as RadioControl;
}

implementation {
    bool pinA;
    bool pinB;
    bool pinC;
    bool pinD;
    bool pinE;
    bool pinF;
    bool oldPinA;
    bool oldPinC;
    bool oldPinE;
    uint16_t valX;
    uint16_t valY;
    bool ADone;
    bool BDone;
    bool CDone;
    bool DDone;
    bool EDone;
    bool FDone;
    bool XDone;
    bool YDone;

    bool inAction;
    message_t msg;
    bool stop;
    bool init;
    uint16_t speed;
    uint16_t init1;
    uint16_t init2;
    uint16_t init3;
    uint16_t angleStep;
    unit8_t actionType;
    uint16_t actionData;

    event void Boot.booted() {
        stop = TRUE;
        init = FALSE;
        speed = 500;
        init1 = 3000;
        init2 = 3000;
        init3 = 3000;
        angleStep = 300;
        call Button.start();
        call RadioControl.start();
    }

    void sendCommand() {
        carMsg* toSend;
        call Leds.led1Toggle();
        toSend = (carMsg*)(call Packet.getPayload(&msg, sizeof(carMsg)));
        toSend->nodeid = TOS_NODE_ID;
        toSend->type = 0;
        toSend->action = actionType;
        toSend->data = actionData;
        if((call AMSend.send(AM_BROADCAST_ADDR, &msg, sizeof(carMsg))) == SUCCESS) {
            inAction = TRUE;
        }
    }

    event void AMSend.sendDone(message_t* message, error_t err) {
        inAction = FALSE;
        call Leds.led1Toggle();
    }

    event void RadioControl.startDone(error_t err) {
        if(err != SUCCESS) {
            call RadioControl.start();
        }
    }

    event void RadioControl.stopDone(error_t err) {

    }

    event void Button.startDone(bool value) {

    }

    event void Button.stopDone(bool value) {

    }

    event void timer.fired() {
        ADone = FALSE;
        BDone = FALSE;
        CDone = FALSE;
        DDone = FALSE;
        EDone = FALSE;
        FDone = FALSE;
        XDone = FALSE;
        YDone = FALSE;
        call Button.pinvalueA();
        call Button.pinvalueB();
        call Button.pinvalueC();
        call Button.pinvalueD();
        call Button.pinvalueE();
        call Button.pinvalueF();
        call adcRead1.read();
        call adcRead2.read();
    }

    void operate() {
        if((pinA != oldPinA) || (!pinB) || (pinC != oldPinC) ||
        (pinE != oldPinE) || (!pinF) ||
        (valX == 0xfff) || (valX == 0x000) ||
        (valY == 0xfff) || (valY == 0x000)) {
            call Leds.led2Toggle();
            if (!pinC) {
                init1 = MIDANGLE;
                init1 = MIDANGLE;
                init3 = MIDANGLE;
                actionType = 7;
                actionData = MIDANGLE;
                sendCommand();
            }
            else if ((pinA) && (!pinB) && (pinC) && (pinE)
            && (pinF) && (valX == 0x000)) {
                if(init1 + angleStep < MAXANGLE){
                    init1 += angleStep;
                }
                actionType = 1;
                actionData = init1;
                if(inAction) {
                    sendCommand();
                }
            }
            else if ((pinA) && (!pinB) && (pinC) && (pinE)
            && (pinF) && (valX == 0xfff)) {
                if(init1 - angleStep > MINANGLE){
                    init1 -= angleStep;
                }
                actionType = 1;
                actionData = init1;
                if(inAction) {
                    sendCommand();
                }
            }
            else if ((pinA) && (pinB) && (pinC) && (pinE)
            && (!pinF) && (valY == 0x000)) {
                if(init2 + angleStep < MAXANGLE){
                    init1 += angleStep;
                }
                actionType = 7;
                actionData = init2;
                if(inAction) {
                    sendCommand();
                }
            }
            else if ((pinA) && (pinB) && (pinC) && (pinE)
            && (!pinF) && (valY == 0xfff)) {
                if(init2 - angleStep > MINANGLE){
                    init2 -= angleStep;
                }
                actionType = 7;
                actionData = init2;
                if(inAction) {
                    sendCommand();
                }
            }
        }
        oldpinA = pinA;
		oldpinC = pinC;
		oldpinE = pinE;
		stop = FALSE;
		}
		else {
			if (!stop) {
				actionType = 6;
				if (!busy) {
					sendCommand();
					call Leds.led0Toggle();
				}
			}
		}
    }

    event void Button.pinvalueADone(bool value) {
        pinA = value;
        ADone = TRUE;
        if (ADone && BDone && CDone && DDone 
        && EDone && FDone && XDone && FDone) {
            operate();
        }
    }

    event void Button.pinvalueBDone(bool value) {
        pinB = value;
        BDone = TRUE;
        if (ADone && BDone && CDone && DDone 
        && EDone && FDone && XDone && FDone) {
            operate();
        }
    }

    event void Button.pinvalueCDone(bool value) {
        pinC = value;
        CDone = TRUE;
        if (ADone && BDone && CDone && DDone 
        && EDone && FDone && XDone && FDone) {
            operate();
        }
    }

    event void Button.pinvalueDDone(bool value) {
        pinD = value;
        DDone = TRUE;
        if (ADone && BDone && CDone && DDone 
        && EDone && FDone && XDone && FDone) {
            operate();
        }
    }

    event void Button.pinvalueEDone(bool value) {
        pinE = value;
        EDone = TRUE;
        if (ADone && BDone && CDone && DDone 
        && EDone && FDone && XDone && FDone) {
            operate();
        }
    }

    event void Button.pinvalueFDone(bool value) {
        pinF = value;
        FDone = TRUE;
        if (ADone && BDone && CDone && DDone 
        && EDone && FDone && XDone && FDone) {
            operate();
        }
    }

    event void adcRead1.readDone(error_t result, uint16_t val){
        if(result == SUCCESS){
            valX = val;
            XDone = TRUE;
			if (ADone && BDone && CDone && DDone 
            && EDone && FDone && XDone && YDone) {
				operate();
			}
        }
        else{
            valX = 0xfff;
        }
    }

    event void adcRead2.readDone(error_t result, uint16_t val){
        if(result == SUCCESS){
            valY = val;
            YDone = TRUE;
			if (ADone && BDone && CDone && DDone 
            && EDone && FDone && XDone && YDone) {
				operate();
			}
        }
        else{
            valY = 0xfff;
        }
    }
}