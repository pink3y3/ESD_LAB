#include <LPC17xx.h>

unsigned int j;
unsigned long LED = 0x00000FF0;

int main(void)
{
    SystemInit();
    SystemCoreClockUpdate();


    LPC_PINCON->PINSEL0 = 0x00000000; // P015-P0.0 GPIO
    LPC_GPIO0->FIODIR = 0x0000FF00; //P0.11-P0.4 as output

    while(1)
    {
        LPC_GPIO0->FIOSET = LED;   // SET P0.11-P0.4
        for (j = 0; j < 10000; j++); // Delay

        LPC_GPIO0->FIOCLR = LED;   // CLEAR P0.11-P0.4
        for (j = 0; j < 10000; j++); //Delay
    }
}
