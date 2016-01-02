/**
 * \project test_spi
 * \author Joshua Vasquez
 * \date September 2015
 */

#include "preamble.h"
#include <SPI.h>

#define CS 10
#define WRITE 14
#define FPGA_RESET 15

const size_t LIST_SIZE = 20;

uint8_t unsorted_list[LIST_SIZE] = {10, 18, 9, 1, 13, 12, 5, 14, 16, 17,
                                    19, 8, 20, 2, 4, 11, 5, 6, 3, 7};
uint8_t sorted_list[LIST_SIZE];

void setup()
{
    Serial.begin(115200);

/// Print build information.
    preamble();
    pinMode(CS, OUTPUT);
    digitalWrite(CS, HIGH);

    pinMode(WRITE, OUTPUT);
    digitalWrite(WRITE, HIGH);

    pinMode(FPGA_RESET, OUTPUT);
    digitalWrite(FPGA_RESET, HIGH);
    digitalWrite(FPGA_RESET, LOW);

    SPI.begin();
    SPI.setClockDivider(SPI_CLOCK_DIV4);
    delay(1000);

}


void loop()
{
// Put the FPGA in a known state
    digitalWrite(FPGA_RESET, HIGH);
    delay(1);
    digitalWrite(FPGA_RESET, LOW);

    delay(5000);
    digitalWrite(WRITE, HIGH);
    digitalWrite(CS, LOW);
    for (uint8_t unsorted_list_index = 0; unsorted_list_index < LIST_SIZE;
         ++unsorted_list_index)
    {
        SPI.transfer(unsorted_list[unsorted_list_index]);
    }
    delayMicroseconds(10);
    digitalWrite(CS, HIGH);
    Serial.println("Unsorted List:");
    for (uint8_t i = 0; i < LIST_SIZE; ++i)
    {
        Serial.println(unsorted_list[i]);
    }
    Serial.println();
    digitalWrite(CS, HIGH);


    delay(1000);


    /// Read back sorted data.
    digitalWrite(WRITE, LOW);
    digitalWrite(CS, LOW);
    for (uint8_t sorted_list_index = 0; sorted_list_index < LIST_SIZE;
         ++sorted_list_index)
    {
        sorted_list[sorted_list_index] = SPI.transfer(0xff);
    }
    delayMicroseconds(10);
    Serial.println("Sorted List:");
    for (uint8_t i = 0; i < LIST_SIZE; ++i)
    {
        Serial.println(sorted_list[i]);
    }
    Serial.println();
    digitalWrite(CS, HIGH);
    delay(2000);
}
