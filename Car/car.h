#ifndef CAR_H
#define CAR_H

typedef struct Command {
  uint8_t action;
  uint16_t data;
} Command;

enum ActionType {
  Arm_First = 1,
  Forward,
  Back,
  TurnLeft,
  TurnRight,
  Stop,
  Arm_Second,
  Arm_Third,
  End
}

#endif