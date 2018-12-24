#include <Timer.h>
#define NEW_PRINTF_SEMANTICS
#include "../common/carMsg.h"

configuration ControlAppC {}

implementation {
    components MainC, ButtonC, LedsC, JoyStickC;
    components ControlC as App;
    components ActiveMessageC;
    components new AMSenderC(AM_radio);
    components PrintfC;
  components SerialStartC;

    components SerialActiveMessageC;
    components new TimerMilliC() as timer;
    
    App.Boot->MainC;
    App.Leds->LedsC;
    App.Button->ButtonC.Button;
    App.adcRead1->JoyStickC.Read1;
    App.adcRead2->JoyStickC.Read2;
    App.timer->timer;
    App.Packet->ActiveMessageC;
    App.AMSend->AMSenderC;
    // App.Receive->ActiveMessageC.Receive[AM_carMsg];
    
    App.SerialPacket->SerialActiveMessageC;
    App.SerialAMSend->SerialActiveMessageC.AMSend[AM_serialMsg];
    
    App.RadioControl->ActiveMessageC;
    App.SerialControl->SerialActiveMessageC;
}