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
        type=2;
        call Resource.request();
    }    
    command void Car.Back(){
        type=3;
        call Resource.request();
    }
    command void Car.TurnLeft(){
        type=4;
        call Resource.request();
    }
    command void Car.TurnRight(){
        type=5;
        call Resource.request();
    }
    command void Car.Stop(){
        type=6;
        call Resource.request();
    }

    command void Car.Arm_First((uint16_t value){
        type=1;
        call Resource.request();
    }

    command void Car.Arm_Second(){
        type=7;
        call Resource.request();
    }

    command void Car.Arm_Third(){
        type=8;
        call Resource.request();
    }

    void operator(){
        while(type <= 7){
            if (type == 0){
            call HplMsp430Usart.tx(0x01);
            }
            else if(type == 1){
                call HplMsp430Usart.tx(0x02);
            }
            else if(type == 2){
                call HplMsp430Usart.tx(type);            
            }
            else if(type == 3){
                call HplMsp430Usart.tx(0x00);
            }
            else if(type == 4){
                call HplMsp430Usart.tx(0x00);
            }
            else if(type == 5){
                call HplMsp430Usart.tx(0xFF);
            }
            else if(type == 6){
                call HplMsp430Usart.tx(0xFF);
            }
            else if(type == 7){
                call HplMsp430Usart.tx(0x00);
            }
            while(!call HplMsp430Usart.isTxEmpty()){
                continue;
            }
            type = type + 1;
        }        
    }

    event void Resource.granted(){
        call HplMsp430Usart.setModeUart(&config);
        call HplMsp430Usart.enableUart();
        U0CTL &= ~SYNC;
        type = 0;
        operator();
    }

}