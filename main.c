#include <avr/io.h>
#include <util/delay.h>
#include <stdbool.h>

#include "process.h"

#define MOTOR_PIN_1 2
#define MOTOR_PIN_2 3
#define MOTOR_PIN_3 4
#define MOTOR_PIN_4 5

#define YELLOW_PIN 0
#define BLUE_PIN 1

#define DELAY 3000

void setup(void);
void loop(void);

int main(int argc, char **argv)
{
  setup();

  while(true)
  {
    loop();
  }

  return 0;
}

void setup(void)
{
  DDRB |= (1 << YELLOW_PIN) | (1 << BLUE_PIN);
  DDRD |= (1 << MOTOR_PIN_1) | (1 << MOTOR_PIN_2) | (1 << MOTOR_PIN_3) | (1 << MOTOR_PIN_4);
  PORTB &= ~(_BV(YELLOW_PIN) | _BV(BLUE_PIN));
  PORTD &= ~(_BV(MOTOR_PIN_1) | _BV(MOTOR_PIN_2) | _BV(MOTOR_PIN_3) | _BV(MOTOR_PIN_4));
}

void loop(void)
{
  onYellowOffBlue();
  normalMotor();
  _delay_ms(DELAY);
  onBlueOffYellow();
  againstMotor();
  _delay_ms(DELAY);
}
