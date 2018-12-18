module AppC {
  uses{
    interface Boot;
    interface Car;
    interface Timer<TMilli> as Timer;
    //interface Receive; 
    interface Leds;
    //interface SplitControl as AMControl;
  }
}
implementation {
  event void Boot.booted() {

  }
  //event void AMControl.startDone(error_t err) {}
  //event void AMControl.stopDone(error_t err) {}
  event void Timer.fired() {

  }
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
      
  }
}
