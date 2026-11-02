#include <LPC17xx.h>
#include <stdio.h>

/* LCD pin definitions */
#define RS_CTRL 0x08000000   /* P0.27 */
#define EN_CTRL 0x10000000   /* P0.28 */
#define DT_CTRL 0x07800000   /* P0.23 to P0.26 */

/* Global variables for LCD */
unsigned long int temp1, temp2;
unsigned char flag1, flag2;

/* ADC variables */
unsigned int adc4, adc5, diff;
char msg[17];

/* Function declarations */
void delay_lcd(unsigned int r1);
void lcd_init(void);
void lcd_com(void);
void lcd_data(void);
void lcd_puts(unsigned char *str);
void lcd_write(void);
void port_write(void);
unsigned int Read_ADC(unsigned int channel);

/* ADC reading function */
unsigned int Read_ADC(unsigned int channel)
{
    unsigned int result;

    /* Select ADC channel, set clock and enable ADC */
    LPC_ADC->ADCR = (1U << channel) |
                    (4U << 8) |
                    (1U << 21);

    /* Start conversion */
    LPC_ADC->ADCR |= (1U << 24);

    /* Wait for conversion to complete */
    do
    {
        result = LPC_ADC->ADGDR;
    } while ((result & (1U << 31)) == 0);

    /* Stop conversion */
    LPC_ADC->ADCR &= ~(7U << 24);

    /* Extract 12-bit ADC result */
    return (result >> 4) & 0xFFF;
}

/* Main program */
int main(void)
{
    SystemInit();
    SystemCoreClockUpdate();

    /* Enable GPIO and ADC peripherals */
    LPC_SC->PCONP |= (1U << 15);
    LPC_SC->PCONP |= (1U << 12);

    /*
       Configure P0.23-P0.31 as GPIO for LCD.
       Clear PINSEL1 bits 14-31.
    */
    LPC_PINCON->PINSEL1 &= ~(0xFFFFC000);

    /* Configure LCD pins as outputs */
    LPC_GPIO0->FIODIR |= DT_CTRL | RS_CTRL | EN_CTRL;

    /* Configure P1.30 as AD0.4 and P1.31 as AD0.5 */
    LPC_PINCON->PINSEL3 &= ~(0xF0000000);
    LPC_PINCON->PINSEL3 |=  (0xF0000000);

    /* Initialize LCD */
    lcd_init();

    while (1)
    {
        /* Read ADC channels 4 and 5 */
        adc4 = Read_ADC(4);
        adc5 = Read_ADC(5);

        /* Calculate absolute difference */
        if (adc4 >= adc5)
            diff = adc4 - adc5;
        else
            diff = adc5 - adc4;

        /* Display heading */
        temp1 = 0x80;
        lcd_com();
        lcd_puts((unsigned char *)"ADC Difference");

        /* Display result */
        temp1 = 0xC0;
        lcd_com();

        sprintf(msg, "%u       ", diff);
        lcd_puts((unsigned char *)msg);

        delay_lcd(50000);
    }
}

/* LCD initialization */
void lcd_init(void)
{
    unsigned int i;

    LPC_GPIO0->FIODIR |= DT_CTRL | RS_CTRL | EN_CTRL;

    flag1 = 0;

    {
        unsigned char init_command[] =
        {
            0x30, 0x30, 0x30, 0x20,
            0x28, 0x0C, 0x06, 0x01, 0x80
        };

        for (i = 0; i < 9; i++)
        {
            temp1 = init_command[i];
            lcd_write();
        }
    }

    flag1 = 1;
}

/* Send LCD command */
void lcd_com(void)
{
    flag1 = 0;
    lcd_write();
}

/* Send LCD character */
void lcd_data(void)
{
    flag1 = 1;
    lcd_write();
}

/* Display string on LCD */
void lcd_puts(unsigned char *str)
{
    while (*str != '\0')
    {
        temp1 = *str;
        lcd_data();
        str++;
    }
}

/* Send command/data to LCD */
void lcd_write(void)
{
    unsigned char high_nibble_only;

    high_nibble_only =
        ((flag1 == 0) &&
         ((temp1 == 0x30) || (temp1 == 0x20)));

    temp2 = temp1 & 0xF0;
    temp2 = temp2 << 19;

    port_write();

    if (!high_nibble_only)
    {
        temp2 = temp1 & 0x0F;
        temp2 = temp2 << 23;
        port_write();
    }
}

/* Write nibble to LCD */
void port_write(void)
{
    LPC_GPIO0->FIOCLR = DT_CTRL;
    LPC_GPIO0->FIOSET = temp2 & DT_CTRL;

    if (flag1 == 0)
        LPC_GPIO0->FIOCLR = RS_CTRL;
    else
        LPC_GPIO0->FIOSET = RS_CTRL;

    LPC_GPIO0->FIOSET = EN_CTRL;
    delay_lcd(1000);
    LPC_GPIO0->FIOCLR = EN_CTRL;
    delay_lcd(10000);
}

/* Delay function */
void delay_lcd(unsigned int r1)
{
    unsigned int r;

    for (r = 0; r < r1; r++)
    {
        __NOP();
    }
}