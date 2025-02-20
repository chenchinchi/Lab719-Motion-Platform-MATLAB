% 主程式
clc;
clear;
close all;

% 初始化平台
platform = MotionPlatform();
platform.enable();
pause(5); % 等待設備啟動完成

% 回歸原點
disp('回歸原點...');
platform.homeXY();
platform.homeZ();
while ~(platform.isMoveCompletedX() && platform.isMoveCompletedY() && platform.isMoveCompletedZ())
    pause(1); % 等待所有軸完成回原點
end
disp('回歸原點完成');

% % 初始化移動參數
% x_distance = 500; % X 軸初始移動距離
% y_distance = 500; % Y 軸初始移動距離
% z_position = 0;   % Z 軸初始位置
% 
% % 平台運動邏輯
% 
% % X 軸增量移動
% if platform.isMoveCompletedX()
%     platform.moveIncrementX(x_distance, platform.maxSpeedX);
%     x_distance = -x_distance; % 翻轉移動方向
% end
% 
% % Y 軸增量移動
% if platform.isMoveCompletedY()
%     platform.moveIncrementY(y_distance, platform.maxSpeedY);
%     y_distance = -y_distance; % 翻轉移動方向
% end
% 
% % Z 軸絕對位置移動
% if platform.isMoveCompletedZ()
%     if z_position == 0
%         z_position = 200; % 移動到 200
%     else
%         z_position = 0;   % 移動到 0
%     end
%         platform.moveAbsoluteZ(z_position, 100); % 速度百分比為100%
% end
