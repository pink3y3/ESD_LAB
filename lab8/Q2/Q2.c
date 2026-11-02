#include <LPC17xx.h>

/*-----------------------------------------
   7-Segment Digit Enable
-----------------------------------------*/

#define FIRST_SEG    0xF87FFFFF
#define SECOND_SEG   0xF8FFFFFF
#define THIRD_SEG    0xF97FFFFF
#define FOURTH_SEG   0xF9FFFFFF


/*-----------------------------------------
   7-Segment codes

   Only 0 and 1 are required
-----------------------------------------*/

unsigned char array_dec[10] =
{
    0x3F,       // 0
    0x06,       // 1
    0x5B,
    0x4F,
    0x66,
    0x6D,
    0x7D,
    0x07,
    0x7F,
    0x6F
};


/*-----------------------------------------
   Ring counter value

   1000
   0100
   0010
   0001
-----------------------------------------*/

unsigned int ring_count = 0;


/*-----------------------------------------
   Timing variables
-----------------------------------------*/

unsigned int count = 0;
unsigned int flag = 0;


/*
   Approximately 1 second.
   Same timing method as your working code.
*/
#define N 1000


/*-----------------------------------------
   Multiplexing
-----------------------------------------*/

unsigned int dig_count = 0;


/*-----------------------------------------
   Function declarations
-----------------------------------------*/

void delay(void);
void display(void);


/*=========================================
                 MAIN
=========================================*/

int main(void)
{
    /*-------------------------------------
       Initialize system
    -------------------------------------*/

    SystemInit();
    SystemCoreClockUpdate();


    /*-------------------------------------
       P0.4 - P0.11
       Seven segment data
    -------------------------------------*/

    LPC_PINCON->PINSEL0 &= 0xFF0000FF;

    LPC_GPIO0->FIODIR |= 0x00000FF0;


    /*-------------------------------------
       P1.23 - P1.26
       Digit enable
    -------------------------------------*/

    LPC_PINCON->PINSEL3 &= 0xFFC03FFF;

    LPC_GPIO1->FIODIR |= 0x07800000;


    /*-------------------------------------
       Start ring counter

       Initial state:

       1000
    -------------------------------------*/

    ring_count = 0;


    /*-------------------------------------
       Main loop
    -------------------------------------*/

    while(1)
    {
        /*---------------------------------
           Generate small delay
        ---------------------------------*/

        delay();


        /*---------------------------------
           Multiplex display
        ---------------------------------*/

        dig_count++;

        if(dig_count == 5)
        {
            dig_count = 1;
        }


        /*---------------------------------
           One second completed
        ---------------------------------*/

        if(flag == 1)
        {
            flag = 0;


            /*--------------------------------
               Move the '1' to next position

               1000
               0100
               0010
               0001
               1000
            --------------------------------*/

            ring_count++;

            if(ring_count == 4)
            {
                ring_count = 0;
            }
        }


        /*---------------------------------
           Refresh display
        ---------------------------------*/

        display();
    }
}


/*=========================================
                 DELAY
=========================================*/

void delay(void)
{
    volatile unsigned int i;


    /* Small delay for multiplexing */

    for(i = 0; i < 1000; i++)
    {
    }


    /* Count small delays */

    count++;


    /* Approximately one second completed */

    if(count >= N)
    {
        flag = 1;

        count = 0;
    }
}


/*=========================================
                DISPLAY
=========================================*/

void display(void)
{
    unsigned int temp1;
    unsigned long int temp2;

    volatile unsigned int i;


    /*-------------------------------------
       Units digit - U8
    -------------------------------------*/

    if(dig_count == 1)
    {
        /*
           Ring states:

           ring_count = 0 -> 0001
           ring_count = 1 -> 0010
           ring_count = 2 -> 0100
           ring_count = 3 -> 1000
        */

        if(ring_count == 0)
            temp1 = 1;
        else
            temp1 = 0;


        LPC_GPIO1->FIOPIN = FIRST_SEG;
    }


    /*-------------------------------------
       Tens digit - U9
    -------------------------------------*/

    else if(dig_count == 2)
    {
        if(ring_count == 1)
            temp1 = 1;
        else
            temp1 = 0;


        LPC_GPIO1->FIOPIN = SECOND_SEG;
    }


    /*-------------------------------------
       Hundreds digit - U10
    -------------------------------------*/

    else if(dig_count == 3)
    {
        if(ring_count == 2)
            temp1 = 1;
        else
            temp1 = 0;


        LPC_GPIO1->FIOPIN = THIRD_SEG;
    }


    /*-------------------------------------
       Thousands digit - U11
    -------------------------------------*/

    else
    {
        if(ring_count == 3)
            temp1 = 1;
        else
            temp1 = 0;


        LPC_GPIO1->FIOPIN = FOURTH_SEG;
    }


    /*-------------------------------------
       Convert 0/1 to seven-segment code
    -------------------------------------*/

    temp1 = temp1 & 0x0F;

    temp2 = array_dec[temp1];


    /*-------------------------------------
       Move P0.0-P0.7 to P0.4-P0.11
    -------------------------------------*/

    temp2 = temp2 << 4;


    /*-------------------------------------
       Send data to display
    -------------------------------------*/

    LPC_GPIO0->FIOPIN = temp2;


    /*-------------------------------------
       Multiplexing delay
    -------------------------------------*/

    for(i = 0; i < 500; i++)
    {
    }


    /*-------------------------------------
       Clear segment data
    -------------------------------------*/

    LPC_GPIO0->FIOCLR = 0x00000FF0;
}