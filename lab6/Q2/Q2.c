#include <LPC17xx.h>

int main()
{
    SystemInit();

    // P0.4 as output (LED)
    LPC_GPIO0->FIODIR |= (1 << 4);

    // P2.12 as input (Switch)
    LPC_GPIO2->FIODIR &= ~(1 << 12);

    while(1)
    {
        if(!(LPC_GPIO2->FIOPIN & (1 << 12)))
            LPC_GPIO0->FIOSET = (1 << 4);   // LED ON
        else
            LPC_GPIO0->FIOCLR = (1 << 4);   // LED OFF
    }
}
