interface Button {
	command void start(); //功能开启，调用startDone
	event void startDone(error_t err);

	command void stop();  //功能关闭，调用stopDone
	event void stopDone(error_t err);
	
	command void pinvalueA();  //获得IO口值
	event void pinvalueADone(bool value);

	command void pinvalueB();  //获得IO口值
	event void pinvalueBDone(bool value);

	command void pinvalueC();  //获得IO口值
	event void pinvalueCDone(bool value);

	command void pinvalueD();  //获得IO口值
	event void pinvalueDDone(bool value);

	command void pinvalueE();  //获得IO口值
	event void pinvalueEDone(bool value);

	command void pinvalueF();  //获得IO口值
	event void pinvalueFDone(bool value);
}
