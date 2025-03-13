# Lab719-Motion-Platform-MATLAB
## 簡介 
為了未來量測實驗方便，且提高重複性，因此以MATLAB結合伺服馬達並且提供連結訊號擷取器(DAQ)介面並實時作圖。  
開發實驗室平移台，其xy軸向為CDHD Servo Drive ，z軸向為TC100 Servo Drive，使用USB-USB typeb將電腦與伺服馬達做連接，並進行控制。

## 使用方法
於MATLAB先建立plane_controller物件，並且於其中指定連接阜  
### sample code
```MATLAB
clc;
clear;
close all;
controller = plane_controller("COM3","COM4");
% 接下來即可根據以下指令集使用
```
![image](https://github.com/user-attachments/assets/4afbf078-7ab6-40c6-a37c-61c801f6de1c)
## MATLAB
使用```serialport.writeline()```寫入指令
訊號終止碼為```CR/LF```
### xy軸 
```MATLAB
x: "\1 {要輸入的指令} \r\n"
y: "\2 {要輸入的指令} \r\n"
```
### z軸
```MATLAB
通訊指令 ASCII
WORD數 = 1 -->  ": + 站號[2byte] + 功能碼[2byte] + 資料位置[4byte] + 資料動作[4byte] + LRC[2byte] + \r\n"
WORD數>=2 -->  ": + 站號[2byte] + 功能碼[2byte] + 寫入開始位置上位[4byte] + 寫入WORD數[4byte] + 第一個WORD[2byte] + 第二個WORD[2byte] + LRC[2byte] + \r\n"
```


## DEMO
https://www.youtube.com/watch?v=Ut5g9TByhBA  
## 
#### 2025-3  
新增了GUI介面、新增了wait功能防止錯誤的控制
![image](https://github.com/user-attachments/assets/7a8ed43a-bb0c-4f8e-bc04-0a97daf96dab)
