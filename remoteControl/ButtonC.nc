configuration ButtonC{
    provides interface Button;
}

implementation {
    components ButtonP;
    components HplMsp430GeneralIOC;
    Button = ButtonP;
    ButtonP.portA -> HplMsp430GeneralIOC.Port60;
    ButtonP.portB -> HplMsp430GeneralIOC.Port21;
    ButtonP.portC -> HplMsp430GeneralIOC.Port61;
    ButtonP.portD -> HplMsp430GeneralIOC.Port23;
    ButtonP.portE -> HplMsp430GeneralIOC.Port62;
    ButtonP.portF -> HplMsp430GeneralIOC.Port26;
}