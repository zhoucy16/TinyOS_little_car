#include "../common/carMsg.h"
#include "car.h"

module RemoteReceiverC {
  uses {
    interface Boot;
    interface Leds;

    interface SplitControl as RadioControl;
    interface SplitControl as SerialControl;

    interface AMSend;
    interface Receive;
    interface AMPacket;
    interface Car;
    interface Timer<TMilli> as Timer;
  }
}

implementation {
  bool radioBusy;
  message_t pkt;

  bool serialBusy;
  uint16_t initStep;
  uint16_t commandHead;
  uint16_t commandTail;

  Command commandQueue[128];

  event void Boot.booted () {
    commandHead = 0;
    commandTail = 0;
    serialBusy = FALSE;
    initStep = 0;

    // call Car.init();
    call RadioControl.start();
    call SerialControl.start();
    // call Car.setMaxSpeed(600);
    // call Car.setMinSpeed(200);
  }

  event void Timer.fired () {

  }

  void ExcuteCommand () {
    if (commandQueue[commandHead].action == 1) {
      serialBusy = TRUE;
      call Leds.led
    }
  }
}