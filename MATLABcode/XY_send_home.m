clc;
clear;
close all;

serial_number = "COM3";%'DN034V26A';
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
ser = serialport(port, 115200,"Timeout",0.1);
configureTerminator(ser,"CR/LF")
flush(ser);

payload = "\2";
% 發送字串到串口
writeline(ser, payload);
disp("已發送: " + payload);
flush(ser);
response = readline(ser);
disp("回應"+response);
payloads = 'INFO';
% 發送字串到串口
writeline(ser, payloads);
disp("已發送: " + payloads);
flush(ser);
response = readline(ser);
disp("回應"+response);
% 用這個可能會有bug 但先頂著用
while ser.NumBytesAvailable ~= 4
    disp(ser.NumBytesAvailable)
    data = readline(ser);
    disp(data); % 处理读取到的数据
end



