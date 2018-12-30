#include <Timer.h>
#include "car.h"
#include "../common/carMsg.h"

module AppC {
  uses{
    interface Boot;
    interface Leds;
    interface Car;
    interface Timer<TMilli> as Timer;
    interface Timer<TMilli> as TimerReset;

    interface Packet;
    interface AMPacket;
    interface AMSend;
    interface SplitControl as AMControl;
    interface Receive;
  }
}
implementation {
  bool automatic;
  uint16_t step;

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      automatic = TRUE;
      step = 0;
      call Timer.startPeriodic(TIMER_PERIOD_AUTO);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer.fired() {
    if(step == 0 || step == 1){
      call Car.Forward(MIDSPEED);
      step++;
    }
    else if(step == 2 || step == 3){
      call Car.Back(MIDSPEED);
      step++;
    }
    else if(step == 4 || step == 5){
      call Car.TurnLeft(MIDSPEED);
      step++;
    }
    else if(step == 6 || step == 7){
      call Car.TurnRight(MIDSPEED);
      step++;
    }
    else if(step == 8 || step == 9){
      call Car.Stop(0);
      step++;
    }
    else if(step == 10){
      call Car.Arm_First(MINANGLE);
      step++;
    }
    else if(step == 11){
      call Car.Arm_First(MAXANGLE);
      step++;
    }
    else if(step == 12){
      call Car.Arm_Second(MINANGLE);
      step++;
    }
    else if(step ==13){
      call Car.Arm_Second(MAXANGLE);
      step++;
    }    
    else if(step >= 14){
      automatic = FALSE;
      call Car.Stop(0);
      call Timer.stop();
    }
  }

  event void AMSend.sendDone(message_t* msg, error_t error) {
  }

  void handleMsg(uint16_t action, uint16_t data) {
    switch (action) {
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
        call Car.Arm_Second(MIDANGLE);
        call TimerReset.startPeriodic(TIMER_PERIOD_RESET);
        break;      
      default:
        break;
    }
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    if (automatic) {
      return msg;
    }
    if (len == sizeof(carMsg)) {
      carMsg* carpkt = (carMsg*)payload;
      handleMsg(carpkt->action, carpkt->data);
    }
    return msg;
  }

  event void TimerReset.fired () {
    call Car.Arm_First(MIDANGLE);
    call TimerReset.stop();
  }
}
