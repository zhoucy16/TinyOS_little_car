configuration JoyStickC {
	provides {
		interface Read<uint16_t> as Read1;
		interface Read<uint16_t> as Read2;
	}
}
implementation {
	components JoyStickP;
	components new AdcReadClientC() as AdcClient1;
	components new AdcReadClientC() as AdcClient2;
	Read1 = AdcClient1;
	Read2 = AdcClient2;
	AdcClient1.AdcConfigure -> JoyStickP.AdcConfigure1;
	AdcClient2.AdcConfigure -> JoyStickP.AdcConfigure2;
}