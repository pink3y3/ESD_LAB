#include <LPC17xx.h>

unsigned int i;
unsigned int j;

int main(void)
{
    SystemInit();
    SystemCoreClockUpdate();

    // P0.4 - P0.11 as GPIO
    LPC_PINCON->PINSEL0 &= 0xFF0000FF;

    // P0.4 - P0.11 as OUTPUT
    LPC_GPIO0->FIODIR |= 0x00000FF0;


    // P2.12 as GPIO
    LPC_PINCON->PINSEL4 &= 0xFCFFFFFF;

    // P2.12 as INPUT
    LPC_GPIO2->FIODIR &= ~(1 << 12);


    i = 0;

    while(1)
    {
        // Check SW2
        if(LPC_GPIO2->FIOPIN & (1 << 12))
        {
            // SW2 = 1 -> UP
            LPC_GPIO0->FIOPIN = (i << 4);

            i++;

            if(i > 255)
                i = 0;
        }
        else
        {
            // SW2 = 0 -> DOWN
            LPC_GPIO0->FIOPIN = (i << 4);

            if(i == 0)
                i = 255;
            else
                i--;
        }

        // Delay
        for(j = 0; j < 500000; j++);
    }
}