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
    //command void Arm_TurnRight();
    //command void Arm_Resrt();
}