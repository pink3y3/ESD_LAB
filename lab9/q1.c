#include <LPC17xx.h>

/* ---------- LCD ---------- */
#define RS_CTRL 0x08000000 // P0.27
#define EN_CTRL 0x10000000 // P0.28
#define DT_CTRL 0x07800000 // P0.23 - P0.26

unsigned long int temp1 = 0, temp2 = 0;
unsigned char flag1 = 0;

void delay_lcd(unsigned int r1);
void lcd_write(void);
void port_write(void);
void lcd_cmd(unsigned char cmd);
void lcd_data(unsigned char data);
void lcd_init(void);
void lcd_string(char *str);

/* ---------- KEYPAD ---------- */

char keymap[4][4] =
{
{'0','1','2','3'},
{'4','5','6','7'},
{'8','9','+','-'},
{'C','C','C','='}
};

char get_key(void);


/* =========================================
MAIN
========================================= */

int main(void)
{
char key;
char op = 0;
int A = 0, B = 0;
int result = 0;
int state = 0;

SystemInit();
SystemCoreClockUpdate();

/* LCD GPIO */
LPC_GPIO0->FIODIR |= DT_CTRL | RS_CTRL | EN_CTRL;

/*
Keypad:
P2.10 - P2.13 = rows (outputs)
P1.23 - P1.26 = columns (inputs)
*/
LPC_PINCON->PINSEL3 &= 0xFFC03FFF;
LPC_PINCON->PINSEL4 &= 0xF00FFFFF;

LPC_GPIO2->FIODIR |= 0x00003C00;
LPC_GPIO1->FIODIR &= ~0x07800000;

lcd_init();

lcd_string("ENTER:");
lcd_cmd(0xC0);

while(1)
{
key = get_key();

/* CLEAR / RESET */
if(key == 'C')
{
A = 0;
B = 0;
op = 0;
state = 0;

lcd_cmd(0x01);
delay_lcd(30000);

lcd_string("ENTER:");
lcd_cmd(0xC0);

continue;
}

/* FIRST NUMBER */
if(state == 0)
{
if(key >= '0' && key <= '9')
{
A = key - '0';

lcd_data(key);

state = 1;
}
}

/* OPERATOR */
else if(state == 1)
{
if(key == '+' || key == '-')
{
op = key;

lcd_data(key);

state = 2;
}
}

/* SECOND NUMBER */
else if(state == 2)
{
if(key >= '0' && key <= '9')
{
B = key - '0';

lcd_data(key);

state = 3;
}
}

/* '=' KEY */
else if(state == 3)
{
if(key == '=')
{
lcd_data('=');

if(op == '+')
result = A + B;
else
result = A - B;

lcd_cmd(0xC0);
lcd_string("RESULT:");

/* Negative result */
if(result < 0)
{
lcd_data('-');
result = -result;
}

/* Result can be 0 - 18 */
if(result >= 10)
{
lcd_data((result / 10) + '0');
lcd_data((result % 10) + '0');
}
else
{
lcd_data(result + '0');
}

state = 4;
}
}
}
}


/* =========================================
KEYPAD FUNCTION
========================================= */

char get_key(void)
{
int row;
unsigned long col;

while(1)
{
for(row = 0; row < 4; row++)
{
/* Clear all rows */
LPC_GPIO2->FIOCLR = 0x00003C00;

/* Make one row HIGH */
LPC_GPIO2->FIOSET = (1 << (10 + row));

delay_lcd(1000);

/* Read columns */
col = LPC_GPIO1->FIOPIN & 0x07800000;

if(col != 0)
{
char key;

if(col & (1 << 23))
key = keymap[row][0];

else if(col & (1 << 24))
key = keymap[row][1];

else if(col & (1 << 25))
key = keymap[row][2];

else
key = keymap[row][3];

/* Debounce */
delay_lcd(30000);

/* Wait until key released */
while((LPC_GPIO1->FIOPIN & 0x07800000) != 0);

delay_lcd(30000);

return key;
}
}
}
}


/* =========================================
LCD
========================================= */

void lcd_init(void)
{
unsigned char init_command[] =
{
0x30, 0x30, 0x30,
0x20,
0x28,
0x0C,
0x06,
0x01,
0x80
};

int i;

flag1 = 0;

for(i = 0; i < 9; i++)
{
temp1 = init_command[i];
lcd_write();
}
}


void lcd_cmd(unsigned char cmd)
{
flag1 = 0;
temp1 = cmd;
lcd_write();
}


void lcd_data(unsigned char data)
{
flag1 = 1;
temp1 = data;
lcd_write();
}


void lcd_string(char *str)
{
while(*str)
{
lcd_data(*str);
str++;
}
}


void lcd_write(void)
{
unsigned char flag2;

flag2 = (flag1 == 1) ?
0 :
((temp1 == 0x30) || (temp1 == 0x20)) ? 1 : 0;

/* Upper nibble */
temp2 = temp1 & 0xF0;
temp2 = temp2 << 19;

port_write();

/* Lower nibble */
if(flag2 == 0)
{
temp2 = temp1 & 0x0F;
temp2 = temp2 << 23;

port_write();
}
}


void port_write(void)
{
LPC_GPIO0->FIOCLR = DT_CTRL;
LPC_GPIO0->FIOSET = temp2 & DT_CTRL;

if(flag1 == 0)
LPC_GPIO0->FIOCLR = RS_CTRL;
else
LPC_GPIO0->FIOSET = RS_CTRL;

LPC_GPIO0->FIOSET = EN_CTRL;

delay_lcd(25);

LPC_GPIO0->FIOCLR = EN_CTRL;

delay_lcd(30000);
}


void delay_lcd(unsigned int r1)
{
unsigned int r;

for(r = 0; r < r1; r++);

return;
}