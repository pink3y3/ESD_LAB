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
-----------------------------------------*/

unsigned char array_dec[10] =
{
    0x3F,
    0x06,
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
   Counter digits
-----------------------------------------*/

unsigned int dig1 = 0;
unsigned int dig2 = 0;
unsigned int dig3 = 0;
unsigned int dig4 = 0;


/*-----------------------------------------
   Timing variables
-----------------------------------------*/

unsigned int count = 0;
unsigned int flag = 0;


/*
   Increase this if counter is still fast.
*/
#define N 1000


/*-----------------------------------------
   Multiplexing
-----------------------------------------*/

unsigned int dig_count = 0;


void delay(void);
void display(void);


/*=========================================
                 MAIN
=========================================*/

int main(void)
{
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
       SW2

       CNB1 pin 7
           |
          FRC
           |
       CNC pin 7
           |
       P0.21
    -------------------------------------*/

    LPC_PINCON->PINSEL1 &= ~(3 << 10);

    /* P0.21 as INPUT */
    LPC_GPIO0->FIODIR &= ~(1 << 21);


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
               SW2 = 1 -> UP
            --------------------------------*/

            if(LPC_GPIO0->FIOPIN & (1 << 21))
            {
                dig1++;

                if(dig1 == 10)
                {
                    dig1 = 0;

                    dig2++;

                    if(dig2 == 10)
                    {
                        dig2 = 0;

                        dig3++;

                        if(dig3 == 10)
                        {
                            dig3 = 0;

                            dig4++;

                            if(dig4 == 10)
                            {
                                dig4 = 0;
                            }
                        }
                    }
                }
            }


            /*--------------------------------
               SW2 = 0 -> DOWN
            --------------------------------*/

            else
            {
                if(dig1 > 0)
                {
                    dig1--;
                }
                else
                {
                    dig1 = 9;

                    if(dig2 > 0)
                    {
                        dig2--;
                    }
                    else
                    {
                        dig2 = 9;

                        if(dig3 > 0)
                        {
                            dig3--;
                        }
                        else
                        {
                            dig3 = 9;

                            if(dig4 > 0)
                            {
                                dig4--;
                            }
                            else
                            {
                                dig4 = 9;
                            }
                        }
                    }
                }
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


    /*
       Small delay.

       volatile is important because
       the old ARM compiler may optimize
       an empty loop away.
    */

    for(i = 0; i < 1000; i++)
    {
    }


    /*
       Count small delays
    */

    count++;


    /*
       N small delays completed
    */

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
       Units
    -------------------------------------*/

    if(dig_count == 1)
    {
        temp1 = dig1;

        LPC_GPIO1->FIOPIN = FIRST_SEG;
    }


    /*-------------------------------------
       Tens
    -------------------------------------*/

    else if(dig_count == 2)
    {
        temp1 = dig2;

        LPC_GPIO1->FIOPIN = SECOND_SEG;
    }


    /*-------------------------------------
       Hundreds
    -------------------------------------*/

    else if(dig_count == 3)
    {
        temp1 = dig3;

        LPC_GPIO1->FIOPIN = THIRD_SEG;
    }


    /*-------------------------------------
       Thousands
    -------------------------------------*/

    else
    {
        temp1 = dig4;

        LPC_GPIO1->FIOPIN = FOURTH_SEG;
    }


    /* Convert to 7-segment code */

    temp1 = temp1 & 0x0F;

    temp2 = array_dec[temp1];


    /* Move P0.0-P0.7 ? P0.4-P0.11 */

    temp2 = temp2 << 4;


    /* Send to display */

    LPC_GPIO0->FIOPIN = temp2;


    /* Multiplexing delay */

    for(i = 0; i < 500; i++)
    {
    }


    /* Clear segment data */

    LPC_GPIO0->FIOCLR = 0x00000FF0;
}