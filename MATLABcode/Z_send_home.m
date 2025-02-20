clc;
clear;
close all;

serial_number = "COM4";%'DN034V26A';
ports = serialportlist("available");
disp(ports);
port = []; % 預設為空

% 搜索目標端口
for i = 1:length(ports)
    if strcmp(ports{i}, serial_number)
        port = ports{i};
        break;
    end
end

% 如果未找到目標端口，拋出錯誤
if isempty(port)
    error("目標串行埠 %s 未找到，請檢查設備連接。", serial_number);
end

% 創建串口物件
ser = serialport(port, 115200,"Timeout",0.05);
configureTerminator(ser,"CR/LF")
flush(ser);

% 原始字符串
payload = ":0106201E0003B8";%原點復歸

% 發送字串到串口
writeline(ser, payload);
disp("已發送: " + payload);

% 接收回應
response = readline(ser);
disp("接收到: " + response);

