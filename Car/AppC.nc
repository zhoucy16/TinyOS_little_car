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
  bool automatic;
  uint16_t step;
  event void Boot.booted() {
    automatic = TRUE;
    step = 0;
    call Timer.startPeriodic(150);
  }
  event void Timer.fired() {
    if(step == 0 || step == 1){
      call Car.Forward();
      step++;
    }
    else if(step == 2)||(step == 3){
      call Car.Back();
      step++;
    }
    else if(step == 4 || step == 5){
      call Car.TurnLeft();
      step++;
    }
    else if(step == 6 || step == 7){
      call Car.TurnRight();
      step++;
    }
    else if(step == 8 || step == 9){
      call Car.Stop();
      step++;
    }
    else if(step == 10){
      call Car.Arm_First(1800);
      step++;
    }
    else if(step == 11){
      call Car.Arm_First(5000);
      step++;
    }
    else if(step == 12){
      call Car.Arm_Second(1800);
      step++;
    }
    else if(step ==13){
      call Car.Arm_Second(5000);
      step++;
    }    
    else if(step >= 14){
      automatic = FALSE;
      Timer.Stop();
    }
  }
}
