interface Car
{
    //Car
    command void Forward(uint16_t value);
    command void Back(uint16_t value);
    command void TurnLeft(uint16_t value);
    command void TurnRight(uint16_t value);
    command void Stop(uint16_t value);

    //Robotic arm
    command void Arm_First(uint16_t value);
    command void Arm_Second(uint16_t value);
    // command void Arm_Third(uint16_t value);
    //command void Arm_TurnRight();
    //command void Arm_Resrt();

    // event
    // event void operationDone(type);

    // settings
    // command void setMaxSpeed(uint16_t speed);
    // command void setMinSpeed(uint16_t speed);
}