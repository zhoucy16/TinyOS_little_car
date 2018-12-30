#include <Timer.h>
#include "../common/carMsg.h"

module ControlC {
    uses interface Boot;
    uses interface Leds;
    uses interface Timer<TMilli> as timer;
    uses interface Button;
    uses interface Read<uint16_t> as adcRead1;
	uses interface Read<uint16_t> as adcRead2;

    uses interface Packet as Packet;
    uses interface Packet as SerialPacket;
    // uses interface Receive as Receive;

    uses interface AMSend as AMSend;
    uses interface AMSend as SerialAMSend;

    uses interface SplitControl as RadioControl;
    uses interface SplitControl as SerialControl;
}

implementation {
    bool pinA;
    bool pinB;
    bool pinC;
    bool pinD;
    bool pinE;
    bool pinF;
    bool oldpinA;
	bool oldpinB;
	bool oldpinC;
    bool oldpinE;
    
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
    bool serialAction;
    message_t msg;
    message_t smsg;

    //uint16_t speed;
    uint16_t init1;
    uint16_t init2;
    uint16_t init3;
    uint16_t angleStep;
    uint8_t actionType;
    uint16_t actionData;
    uint16_t currentSpeed;
    bool reset;

    event void Boot.booted() {
        //speed = 500;
        init1 = 3000;
        init2 = 3000;
        angleStep = 300;
        currentSpeed = 500;
        oldpinA = TRUE;
		oldpinC = TRUE;
		oldpinE = TRUE;
        reset = FALSE;
        call Button.start();
        call RadioControl.start();
        call SerialControl.start();
    }

    void sendCommand() {
        carMsg* toSend;
        toSend = (carMsg*)(call Packet.getPayload(&msg, sizeof(carMsg)));
        toSend->action = actionType;
        toSend->data = actionData;
        if((call AMSend.send(AM_BROADCAST_ADDR, &msg, sizeof(carMsg))) == SUCCESS) {
            inAction = TRUE;
        }
    }

    void resetSecond() {
        reset = FALSE;
        actionType = 1;
        init1 = MIDANGLE;
        actionData = MIDANGLE;
        if(!inAction) {
            sendCommand();
        }
    }

    event void AMSend.sendDone(message_t* message, error_t err) {
        inAction = FALSE;
    }

    event void SerialAMSend.sendDone(message_t* message, error_t err) {
        serialAction = FALSE;
    }

    event void RadioControl.startDone(error_t err) {
        if(err != SUCCESS) {
            call RadioControl.start();
        }
    }

    event void RadioControl.stopDone(error_t err) {

    }

    event void SerialControl.startDone(error_t err) {
        if(err != SUCCESS) {
            call SerialControl.start();
        }
        else {
            call timer.startPeriodic(TIMER_PERIOD_MILLI);
        }
    }

    event void SerialControl.stopDone(error_t err) {

    }

    event void Button.startDone(bool value) {

    }

    event void Button.stopDone(bool value) {

    }

    event void timer.fired() {
        ADone = TRUE;//A NOT USED
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
        if((!pinA) || (!pinB) || (!pinC) || (!pinE) || (!pinF) ||
        (valX == 0xfff) || (valX == 0x000) || 
        (valY == 0xfff) || (valY == 0x000)) {
            //小车前进
            if ((valY == 0x000) && (pinA) && (pinB) && (pinC) && (pinE) && (pinF)) {
                call Leds.set(1);
                actionType = 2;
                actionData = MIDSPEED;
                if(!inAction) {
                    sendCommand();
                }
            }
            //小车后退
            else if ((valY == 0xfff) && (pinA) && (pinB) && (pinC) && (pinE) && (pinF)) {
                call Leds.set(2);
                actionType = 3;
                actionData = MIDSPEED;
                if(!inAction) {
                    sendCommand();
                }
            }
            //小车左转
            else if ((valX == 0x000) && (pinA) && (pinB) && (pinC) && (pinE) && (pinF)) {
                call Leds.set(3);
                actionType = 4;
                actionData = MIDSPEED;
                if(!inAction) {
                    sendCommand();
                }
            }
            //小车右转
            else if ((valX == 0xfff) && (pinA) && (pinB) && (pinC) && (pinE) && (pinF)) {
                call Leds.set(4);
                actionType = 5;
                actionData = MIDSPEED;
                if(!inAction) {
                    sendCommand();
                }
            }
            //机械臂上升
            else if ((!pinB) && (pinA) && (pinC) && (pinE) && (pinF)) {
                call Leds.set(6);
                if(init1 + angleStep < MAXANGLE){
                    init1 += angleStep;
                } else {
                    init1 = MAXANGLE;
                }
                actionType = 1;
                actionData = init1;
                if(!inAction) {
                    sendCommand();
                }
            }
            //机械臂下降
            else if ((!pinC) && (pinA) && (pinB) && (pinE) && (pinF)) {
                call Leds.set(6);
                if(init1 - angleStep > MINANGLE){
                    init1 -= angleStep;
                } else {
                    init1 = MINANGLE;
                }
                actionType = 1;
                actionData = init1;
                if(!inAction) {
                    sendCommand();
                }
            }
            //机械臂左转 //pinE
            else if ((!pinE) && (pinA) && (pinB) && (pinC) && (pinF)) {
                call Leds.set(7);
                if(init2 - angleStep > MINANGLE){
                    init2 -= angleStep;
                } else {
                    init2 = MINANGLE;
                }
                actionType = 7;
                actionData = init2;
                if(!inAction) {
                    sendCommand();
                }
            }
            //机械臂右转
            else if ((!pinF) && (pinA) && (pinB) && (pinC) && (pinE)) {
                call Leds.set(7);
                if(init2 + angleStep < MAXANGLE){
                    init2 += angleStep;
                } else {
                    init2 = MAXANGLE;
                }
                actionType = 7;
                actionData = init2;
                if(!inAction) {
                    sendCommand();
                }
            }
            //机械臂归位
            else if ((!pinA) && (pinB) && (pinC) && (pinE) && (pinF)) {
                call Leds.set(0);
                reset = TRUE;
                actionType = 8;
                init2 = MIDANGLE;
                actionData = MIDANGLE;
                if(!inAction) {
                    sendCommand();
                }
            }
        }
		else {
            call Leds.set(5);
			actionType = 6;
			if (!inAction) {
			    sendCommand();
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