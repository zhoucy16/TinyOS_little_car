interface Car
{
    //Car
    command void Forward();
    command void Back();
    command void TurnLeft();
    command void TurnRight();
    command void Stop();

    //Robotic arm
    command void Arm_First();
    command void Arm_Second();
    command void Arm_Third();

    // settings
    command void setMaxSpeed(uint16_t speed);
    command void setMinSpeed(uint16_t speed);
}