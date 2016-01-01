#include "preamble.h"

void preamble(void)
{
  Serial.println();
  Serial.flush();
  Serial.print("Working Branch: ");
  Serial.flush();
  Serial.println(BRANCH);
  Serial.flush();
  Serial.print("Author: ");
  Serial.flush();
  Serial.println(AUTHOR);
  Serial.flush();
  Serial.print("Build Date: ");
  Serial.flush();
  Serial.println(BUILD_DATE);
  Serial.flush();
}
