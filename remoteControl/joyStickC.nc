configuration JoyStickC {
	provides {
		interface Read<uint16_t> as readX;
		interface Read<uint16_t> as readY;
	}
}
implementation {
	components JoyStickP;
	components new AdcReadClientC() as AdcClientX;
	components new AdcReadClientC() as AdcClientY;
	readX = AdcClientX;
	readY = AdcClientY;
	AdcClientX.AdcConfigure -> JoyStickP.AdcConfigure1;
	AdcClientY.AdcConfigure -> JoyStickP.AdcConfigure2;
}