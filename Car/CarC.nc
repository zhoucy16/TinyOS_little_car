configuration CarC {
  provides {
    interface Car;
  }
}

implementation {
  components CarP;
  components HplMsp430Usart0C;
  components new Msp430Uart0C();
  Car=CarP;
  
  CarP.HplMsp430Usart -> HplMsp430Usart0C;
  CarP.Resource -> Msp430Uart0C;
}
