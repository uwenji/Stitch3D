#include <OpenCM904.h>
#include <DynamixelSDK.h>
#include <DynamixelWorkbench.h>
#include <SPI.h>

#define DEVICE_NAME "1"
DynamixelWorkbench dxl_wb;
#define BAUDRATE  1000000
#define Needle_ID  6
#define Wheel_L_ID  2
#define Wheel_R_ID  4
#define Hook_ID 5
#define INPUT_SIZE 35

//=====================position & velocity==============
int32_t needle_up = 340; //init 180 
int32_t needle_take = 640; //for hooking 
int32_t needle_down = 960; // lowest, 900, 960
int32_t needleVelocity = 1023;
int32_t hookingVelocity = 1023;
//=====================hook & velocities==============
int32_t posHook = 900;
int32_t preHook = 700;
int32_t zoneEnter = 1022;
int32_t zoneExit = 400;
int32_t hookVelocity = 800; //680
int32_t hookAcceleration = 0;

unsigned long enteredMillis = 0;
const long deadzoneInterval = 100;

// L:[0], R:[1], Needle:[2], StitchON:[3]
int32_t controls[4] = {0,0,0,0};
uint8_t ids[4] = {Wheel_L_ID, Wheel_R_ID,  Needle_ID, Hook_ID};

//=====================Wheel setup=======================
unsigned long wheelMillis = 0;
const long WalkInterval = 350; //350

//========================SPI============================
char input[INPUT_SIZE + 1];

/*
    SPI Slave Demo Sketch
    Connect the SPI Master device to the following pins on the esp8266:

    GPIO    LOLIN    Name  |   OPM9
  ===================================
     15       D8       SS   |   D22
     13       D7      MOSI  |   D21
     12       D6      MISO  |   D20
     14       D5      SCK   |   D19

    Note: If the ESP is booting at a moment when the SPI Master has the Select line HIGH (deselected)
    the ESP8266 WILL FAIL to boot!
    See SPISlave_SafeMaster example for possible workaround
    
    L : + A B C D & R : + A B C D & N : A B C D & S : F
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5
*/
class ESPMaster {
    private:
        uint8_t _ss_pin;
        void _pulseSS() {
            digitalWrite(_ss_pin, HIGH);
            delayMicroseconds(5);
            digitalWrite(_ss_pin, LOW);
        }
    public:
        ESPMaster(uint8_t pin): _ss_pin(pin) {}
        void begin() {
            pinMode(_ss_pin, OUTPUT);
            _pulseSS();
        }

        uint32_t readStatus() {
            _pulseSS();
            SPI.transfer(0x04);
            uint32_t status = (SPI.transfer(0) | ((uint32_t)(SPI.transfer(0)) << 8) | ((uint32_t)(SPI.transfer(0)) << 16) | ((uint32_t)(SPI.transfer(0)) << 24));
            _pulseSS();
            return status;
        }

        void writeStatus(uint32_t status) {
            _pulseSS();
            SPI.transfer(0x01);
            SPI.transfer(status & 0xFF);
            SPI.transfer((status >> 8) & 0xFF);
            SPI.transfer((status >> 16) & 0xFF);
            SPI.transfer((status >> 24) & 0xFF);
            _pulseSS();
        }

        void readData(uint8_t * data) {
            _pulseSS();
            SPI.transfer(0x03);
            SPI.transfer(0x00);
            for (uint8_t i = 0; i < 36; i++) {
                data[i] = SPI.transfer(0);
            }
            _pulseSS();
        }

        void writeData(uint8_t * data, size_t len) {
            uint8_t i = 0;
            _pulseSS();
            SPI.transfer(0x02);
            SPI.transfer(0x00);
            while (len-- && i < 36) {
                SPI.transfer(data[i++]);
            }
            while (i++ < 36) {
                SPI.transfer(0);
            }
            _pulseSS();
        }

        String readData() {
            char data[37];
            data[36] = 0;
            readData((uint8_t *)data);
            return String(data);
        }

        void writeData(const char * data) {
            writeData((uint8_t *)data, strlen(data));
        }
};

ESPMaster esp(SS);

void send(const char * message) {
  Serial.print("Master: ");
  Serial.println(message);
  esp.writeData(message);
  delay(10);
  Serial.print("Slave: ");
  String spiText = esp.readData();
  strcpy(input, spiText.c_str());
  byte Size = spiText.length();

  input[Size] = 0;
  //example_____0:33&1:-44 = L:33,R:-44
  int ID;
  char* command = strtok(input, "&");
  while (command != 0)
  {
    char* separator = strchr(command, ':');
    if (separator != 0)
    {
      *separator = 0;
      int ID = atoi(command);
      ++separator;
      int velocity;
      if(separator[0] != '-')
        velocity = atoi(separator);
      else{
        velocity = atoi(separator);
        velocity = velocity * 1;}
      controls[ID] = velocity;
    }
    command = strtok(0, "&");
  }
  Serial.println(String(controls[0]) +","+ String(controls[1]) +","+ String(controls[2]) +","+ String(controls[3]));
}


//=====================End declare========================
//========================MAIN============================

void setup()
{
  Serial.begin(115200);
  SPI.begin();
  esp.begin();
  delay(1000);
  send("Hello Slave!");

  //=================Dynamixel protocal=================
  //====================================================
  const char *log;
  bool result = false;

  uint16_t model_number = 0;
  result = dxl_wb.init(DEVICE_NAME, BAUDRATE, &log);
  if (result != false){
    Serial.println("Succeeded to init");
  }

  for(int i = 0; i < 4; i++){
    result = dxl_wb.ping(ids[i], &model_number, &log);
    if (result != false){
    Serial.println("Succeeded to ping");
    }
  }

  for(int i = 0; i < 2; i++){
    dxl_wb.wheelMode(ids[i], (int32_t)0, &log);
    dxl_wb.goalVelocity(ids[i], controls[i], &log);
    dxl_wb.torqueOn(ids[i]);
    dxl_wb.itemWrite(ids[i], "Torque Limit", (int32_t)512);
  }

  dxl_wb.jointMode(Hook_ID,hookVelocity,(int32_t)10, &log);
  dxl_wb.jointMode(Needle_ID,needleVelocity,(int32_t)10, &log);
  dxl_wb.goalPosition(Needle_ID, needle_up);
}

int patternMode = 1;
int previousWheel = -1;
int wheelDriver = 0;
int State = 0;

void loop()
{ 
  // TODO:
  // [0]: needle position
  int32_t needleMoving = 0;
  int32_t hookMoving = 0;
  Serial.println("STATE_____[" + String(State) +"]");
  switch(State){
    //================NEEDLE/HOOK MOVING TEST================
    //case 1: case 3: case 5: case 7: case 9: case 11: case 15:
    case 1: case 3: case 5: case 7: case 9: case 11: case 15: case 17:{
      dxl_wb.itemRead(Needle_ID, "Moving", &needleMoving);
      dxl_wb.itemRead(Hook_ID, "Moving", &hookMoving);
      if(needleMoving == 0 && hookMoving == 0){
        State += 1;
      }
    }break;

    //=================START STITCH=================
    case 0:{
      dxl_wb.goalPosition(Needle_ID, needle_up);
      send("Update?");
      if(controls[3] == 1){
        State += 1;
      } else {
        State += 18;
      }
    }break;

    case 2:{
      dxl_wb.goalPosition(Hook_ID, preHook);
      send("Update?");
      if(controls[3] == 1){
        State += 1;
      } else {
        State += 16;
      }
    }break;
    
    case 4:{
      dxl_wb.goalPosition(Needle_ID, needle_down);
      State += 1;
    }break;

    case 6:{
      dxl_wb.goalPosition(Hook_ID, posHook);
      State += 1;
    }break;

    case 8:{
      dxl_wb.goalPosition(Needle_ID, needle_take);
      State += 1;
    }break;

    case 10:{
      dxl_wb.goalPosition(Hook_ID, zoneEnter);
      State += 1;
    }break;

    case 12:{ // wheel mode to pass deadzone
      dxl_wb.wheelMode(Hook_ID, (int32_t)40);
      dxl_wb.goalVelocity(Hook_ID, hookVelocity);
      enteredMillis = millis(); // record the into deadzone
      State += 1;
    }break;

    case 13:{ // passing deadzone
      unsigned long presentMills = millis();
      if(presentMills - enteredMillis >= deadzoneInterval){
        State += 1; // jump to next state
      }
    }break;
    
    case 14:{ // deadzone End
      dxl_wb.jointMode(Hook_ID, hookVelocity, hookAcceleration);
      dxl_wb.goalPosition(Hook_ID, zoneExit);
      State += 1;
    }break;

    case 16:{ // end hook
      dxl_wb.jointMode(Hook_ID, hookVelocity, hookAcceleration);
      dxl_wb.goalPosition(Hook_ID, preHook);
      State += 1;
    }break;

    case 18:{ // withdraw thread
      dxl_wb.goalPosition(Needle_ID, needle_up);
      send("Update?");
      wheelMillis = millis();
      wheelDriver += 1;
      State += 1;
    }break;

    //===============walk===============
    case 19:{
      
      dxl_wb.goalVelocity(Wheel_L_ID, -controls[0]);
      dxl_wb.goalVelocity(Wheel_R_ID, controls[1]);
      
      unsigned long presentMills = millis();
      if(presentMills - wheelMillis >= WalkInterval){
        State += 1; // jump to next state
      }
    }break;

    case 20:{
      dxl_wb.goalVelocity(Wheel_L_ID, (int32_t)0);
      dxl_wb.goalVelocity(Wheel_R_ID, (int32_t)0);
      State = 1; // back init, is read to needle_up
    }break;
  }
  
}
