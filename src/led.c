#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>

void setBit(volatile uint8_t *reg, uint8_t bit) 
{ 
  *reg |= (1 << bit); 
}

void clearBit(volatile uint8_t *reg, uint8_t bit)
{
  *reg &= ~(1 << bit);
}

void onYellowOffBlue(void)
{
  //PORTB |= (1 << PORTB0);
  //PORTB &= ~(1 << PORTB1);
  setBit(&PORTB, PORTB0);
  clearBit(&PORTB, PORTB1);
}

void onBlueOffYellow(void)
{
  setBit(&PORTB, PORTB1);
  clearBit(&PORTB, PORTB0);
}
