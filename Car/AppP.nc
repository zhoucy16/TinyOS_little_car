configuration AppP {

}

implementation {
  components MainC;
  components LedsC;
  components AppC as App;
  components new TimerMilliC() as Timer;
  //components ActiveMessageC;
  //components new AMReceiverC();
  components CarC;

  App.Boot -> MainC;
  App.Timer -> Timer;
  //App.AMControl -> ActiveMessageC;
  //App.Receive -> AMReceiverC;
  App.Car -> CarC;
}
