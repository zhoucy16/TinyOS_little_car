#include "../common/carMsg.h"
#include "car.h"

#define QUEUELEN 128

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
  bool automatic;
  bool radioBusy;
  message_t pkt;

  bool serialBusy;
  uint16_t initStep;
  uint16_t commandHead;
  uint16_t commandTail;

  Command commandQueue[QUEUELEN];

  event void Boot.booted () {
    automatic = TRUE;
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
    if (commandHead == commandTail) {
      return;
    }

  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    if (automatic) {
      return msg;
    }
    if (len == sizeof(carMsg)) {
      carMsg* carpkt = (carMsg*)payload;
      commandQueue[commandTail].action = carpkt.action;
      commandQueue[commandTail].data = carpkt.data;
      commandTail = (commandTail + 1) / QUEUELEN;
    }
    return msg;
  }

  void handleMsg() {
    uint8_t action = commandQueue[commandHead].action;
    uint16_t data = commandQueue[commandHead].data;
    commandHead = (commandHead + 1) / QUEUELEN;
    // judge correct
    switch action {
      case 1:
        call Car.Arm_First(data);
        break;
      case 2:
        call Car.Forward(data);
        break;
      case 3:
        call Car.Back(data);
        break;
      case 4:
        call Car.TurnLeft(data);
        break;
      case 5:
        call Car.TurnRight(data);
        break;
      case 6:
        call Car.Stop(data);
        break;
      case 7:
        call Car.Arm_Second(data);
        break;
      case 8:
        call Car.Arm_third(data);
        break;
      default:
        break;
    }
  }

}