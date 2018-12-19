module ButtonP {
    provides {
        interface Button;
    }

    uses {
        interface HplMsp430GeneralIO as portA;
        interface HplMsp430GeneralIO as portB;
        interface HplMsp430GeneralIO as portC;
        interface HplMsp430GeneralIO as portD;
        interface HplMsp430GeneralIO as portE;
        interface HplMsp430GeneralIO as portF;
    }
}

implementation {
    bool pinA;
    bool pinB;
    bool pinC;
    bool pinD;
    bool pinE;
    bool pinF;
    error_t err;

    command void Button.start() {
        call portA.clr();
        call portA.makeInput();
        call portB.clr();
        call portB.makeInput();
        call portC.clr();
        call portC.makeInput();
        call portD.clr();
        call portD.makeInput();
        call portE.clr();
        call portE.makeInput();
        call portF.clr();
        call portF.makeInput();
        signal Button.startDone(SUCCESS);
    }

    command void Button.stop() {
        signal Button.startDone(SUCCESS);
    }

    command void Button.pinvalueA() {
        pinA = call portA.get();
        signal Button.pinvalueADone(pinA);
    }

    command void Button.pinvalueB() {
        pinB = call portB.get();
        signal Button.pinvalueBDone(pinB);
    }

    command void Button.pinvalueC() {
        pinC = call portC.get();
        signal Button.pinvalueCDone(pinC);
    }

    command void Button.pinvalueD() {
        pinD = call portD.get();
        signal Button.pinvalueDDone(pinD);
    }

    command void Button.pinvalueE() {
        pinE = call portE.get();
        signal Button.pinvalueEDone(pinE);
    }

    command void Button.pinvalueF() {
        pinF = call portF.get();
        signal Button.pinvalueFDone(pinF);
    }
}