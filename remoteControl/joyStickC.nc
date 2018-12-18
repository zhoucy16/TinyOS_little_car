configuration JoyStickC {
	provides {
		interface Read<uint16_t> as read1;
		interface Read<uint16_t> as read2;
	}
}
implementation {
	components JoyStickP;
	components new AdcReadClientC() as AdcClient1;
	components new AdcReadClientC() as AdcClient2;
	read1 = AdcClient1;
	read2 = AdcClient2;
	AdcClient1.AdcConfigure -> JoyStickP.AdcConfigure1;
	AdcClient2.AdcConfigure -> JoyStickP.AdcConfigure2;
}