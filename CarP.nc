module CarP {
    provides {
        interface Car;
    }

    uses {
        interface Resource;
        interface HplMsp430Usart;
    }
}

implementation {
    msp430_uart_union_config_t config = {
		{
			utxe: 1,
			urxe: 1,
			ubr: UBR_1MHZ_115200,
			umctl: UMCTL_1MHZ_115200,
			ssel: 0x02,
			pena: 0,
			pev: 0,
			spb: 0,
			clen: 1,
			listen: 0,
			mm: 0,
			ckpl: 0,
			urxse: 0,
			urxeie: 0,
			urxwie: 0,
			utxe: 1,
			urxe: 1
		}
	};

    command void Car.Forward(){
        call Resource.request();
    }    
    command void Car.Back(){
        call Resource.request();
    }
    command void Car.TurnLeft(){
        call Resource.request();
    }
    command void TurnRight(){
        call Resource.request();
    }
    command void Stop(){
        call Resource.request();
    }

    void operator(){
        if (type == 0){
            call HplMsp430Usart.tx(0x01);
        }
        else if(type == 1){
            call HplMsp430Usart.tx(0x02);
        }

    }

    event void Resource.granted(){
        call HplMsp430Usart.setModeUart(&config);
        call HplMsp430Usart.enableUart();
        U0CTL &= ~SYNC;
        operator();


    }

}