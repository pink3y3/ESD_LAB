#include <LPC17xx.h>

int main(void)
{
    unsigned int i;
    unsigned int j;

    SystemInit();

    // P0.4 to P0.11 as GPIO
    LPC_PINCON->PINSEL0 &= 0xFF0000FF;

    // P0.4 to P0.11 as output
    LPC_GPIO0->FIODIR |= 0x00000FF0;

    while(1)
    {
        for(i = 0; i < 256; i++)
        {
            // Display 8-bit binary count
            LPC_GPIO0->FIOPIN = i << 4;

            // Larger delay = slower counting
            for(j = 0; j < 500000; j++);
        }
    }
}
