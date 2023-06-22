#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>

void setMotorPin(uint8_t pin)
{
  PORTD |= _BV(pin);
  _delay_ms(10);
  PORTD &= ~_BV(pin);
}

void normalMotor(void)
{
  for(int i = 0; i < 512; i++)
  {
    setMotorPin(PORTD5);
    setMotorPin(PORTD4);
    setMotorPin(PORTD3);
    setMotorPin(PORTD2);
  }
}

void againstMotor(void)
{
  for(int i = 0; i < 512; i++)
  {
    setMotorPin(PORTD2);
    setMotorPin(PORTD3);
    setMotorPin(PORTD4);
    setMotorPin(PORTD5);
  } 
}
