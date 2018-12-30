#include <Timer.h>
#include "../common/carMsg.h"

configuration AppP {

}

implementation {
  components MainC;
  components LedsC;
  components AppC as App;
  components new TimerMilliC() as Timer;
  components new TimerMilliC() as TimerReset;
  components ActiveMessageC;
  components new AMReceiverC(AM_radio);
  components CarC;

  App.Boot -> MainC;
  App.Timer -> Timer;
  App.TimerReset -> TimerReset;
  App.Leds -> LedsC;
  App.AMControl -> ActiveMessageC;
  App.Receive -> AMReceiverC;
  App.Car -> CarC;
}
