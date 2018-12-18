#include "car.h"

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
	enum ActionType type;
    uint8_t step;
	uint16_t data;
	uint16_t maxspeed, minspeed;
	uint16_t initing;

    command void Car.Forward(){
        type = Forward;
        call Resource.request();
    }    
    command void Car.Back(){
        type = Back;
        call Resource.request();
    }
    command void Car.TurnLeft(){
        type = TurnLeft;
        call Resource.request();
    }
    command void Car.TurnRight(){
        type = TurnRight;
        call Resource.request();
    }
    command void Car.Stop(){
        type = Stop;
        call Resource.request();
    }

    command void Car.Arm_First(uint16_t value){
        type = Arm_First;
        data = value;
        call Resource.request();
    }

    command void Car.Arm_Second(uint16_t value){
        type = Arm_Second;
        data = value;
        call Resource.request();
    }

    command void Car.Arm_Third(){
        type = Arm_Third;
        call Resource.request();
    }

    void operator(){
        while(step <= 7){
            if (step == 0){
                call HplMsp430Usart.tx(0x01);
            }
            else if(step == 1){
                call HplMsp430Usart.tx(0x02);
            }
            else if(step == 2){
                call HplMsp430Usart.tx(type);            
            }
            else if(step == 3){
                call HplMsp430Usart.tx(0x00);
            }
            else if(step == 4){
                call HplMsp430Usart.tx(0x00);
            }
            else if(step == 5){
                call HplMsp430Usart.tx(0xFF);
            }
            else if(step == 6){
                call HplMsp430Usart.tx(0xFF);
            }
            else if(step == 7){
                call HplMsp430Usart.tx(0x00);
            }
            while(!call HplMsp430Usart.isTxEmpty()){
                continue;
            }
            step = step + 1;
        }        
    }

    event void Resource.granted(){
        call HplMsp430Usart.setModeUart(&config);
        call HplMsp430Usart.enableUart();
        U0CTL &= ~SYNC;
        step = 0;
        operator();
    }

}