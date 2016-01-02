/**
 * \project test_spi
 * \author Joshua Vasquez
 * \date September 2015
 */

#include "preamble.h"
#include <SPI.h>

#define CS 10
#define WRITE 14

uint8_t unsorted_list[10] = {10, 8, 9, 1, 3, 2, 5, 4, 6, 7};
uint8_t sorted_list[10];

void setup()
{
    Serial.begin(115200);

/// Print build information.
    preamble();
    pinMode(CS, OUTPUT);
    digitalWrite(CS, HIGH);

    pinMode(WRITE, OUTPUT);
    digitalWrite(WRITE, HIGH);

    SPI.begin();
    SPI.setClockDivider(SPI_CLOCK_DIV4);
    delay(1000);

}


void loop()
{
    delay(5000);
    digitalWrite(WRITE, HIGH);
    digitalWrite(CS, LOW);
    for (uint8_t unsorted_list_index = 0; unsorted_list_index < 10; ++unsorted_list_index)
    {
        SPI.transfer(unsorted_list[unsorted_list_index]);
    }
    delayMicroseconds(10);
    digitalWrite(CS, HIGH);
    Serial.println("Unsorted List:");
    for (uint8_t i = 0; i < 10; ++i)
    {
        Serial.println(unsorted_list[i]);
    }
    Serial.println();
    digitalWrite(CS, HIGH);


    delay(1000);


    /// Read back sorted data.
    digitalWrite(WRITE, LOW);
    digitalWrite(CS, LOW);
    for (uint8_t sorted_list_index = 0; sorted_list_index < 10;
         ++sorted_list_index)
    {
        sorted_list[sorted_list_index] = SPI.transfer(0xff);
    }
    delayMicroseconds(10);
    Serial.println("Sorted List:");
    for (uint8_t i = 0; i < 10; ++i)
    {
        Serial.println(sorted_list[i]);
    }
    Serial.println();
    digitalWrite(CS, HIGH);
    delay(2000);
}
