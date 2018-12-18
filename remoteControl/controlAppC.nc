configuration controlAppC {}

implementation {
    components MainC, ButtonC, LedsC, JoyStickC;
    components ControlC as App;
    components ActiveMessageC;
    //components SerialActiveMessageC;
    components new TimerMilliC() as timer;
    
    App.Boot->MainC;
    App.Leds->LedsC
    App.Button->ButtonC.Button;
    App.adcRead1->JoyStickC.Read1;
    App.adcRead2->JoyStickC.Read2；
    App.timer->timer;
    App.Packet->ActiveMessageC;
    App.AMSend->ActiveMessageC.AMSend[AM_carMsg];
    App.Receive->ActiveMessageC.Receive[AM_carMsg];
    App.RadioControl->ActiveMessageC;
}