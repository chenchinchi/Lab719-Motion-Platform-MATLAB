classdef plane_controller < handle
    properties
        ser_xy % Serial port object
        ser_z
    end

    methods
        function obj = plane_controller(port_xy,port_z)%初始化
            % Set up serial communication
            obj.ser_xy = serialport(port_xy, 115200, "Timeout",0.05); 
            obj.ser_z = serialport(port_z, 115200, "Timeout",0.05); 
            configureTerminator(obj.ser_xy, "CR/LF");
            configureTerminator(obj.ser_z, "CR/LF");
            flush(obj.ser_xy);
            flush(obj.ser_z);
            obj.send_x("CLEARFAULTS");
            obj.send_y("CLEARFAULTS");
            obj.send_x("EN");
            obj.send_y("EN");
            
        end
        %%
        %%相對移動
        function response = move_x_INC(obj,dis_mm,speed_mm_s)
            dis = round(dis_mm*1000);
            payload = strjoin(["MOVEINC", dis, speed_mm_s], " ");
            response = obj.send_x(payload);
        end
        function response = move_y_INC(obj,dis_mm,speed_mm_s)
            dis = round(dis_mm*1000);
            payload = strjoin(["MOVEINC", dis, speed_mm_s], " ");
            response = obj.send_y(payload);
        end
        %%
        %%絕對移動
        function response = move_x_ABS(obj,dis_mm,speed_mm_s)
            dis = round(dis_mm*1000);
            payload = strjoin(["MOVEABS", dis, speed_mm_s], " ");
            response = obj.send_x(payload);
        end
        function response = move_y_ABS(obj,dis_mm,speed_mm_s)
            dis = round(dis_mm*1000);
            payload = strjoin(["MOVEABS", dis, speed_mm_s], " ");
            response = obj.send_y(payload);
        end
        function response = move_z_ABS(obj,position_mm,speed_percentage)
            speed_percentage = round(speed_percentage);
            if speed_percentage>100
                speed_percentage=100;
            end
            if speed_percentage<0
                speed_percentage=0;
            end
            %disp(dec2hex(speed_percentage))
            response = obj.send_z("06201400"+dec2hex(speed_percentage,2));
            position_mm_times_100 = max(round(position_mm * 100), 0);
            response = response +"\n"+obj.send_z("102002000204"+dec2hex(position_mm_times_100,8));
            response = response +"\n"+obj.send_z("06201E0001");
            
        end
        %%
        %%傳送訊息
        function response = send_x(obj, message)
            axis ="1";
            writeline(obj.ser_xy, sprintf("\\%s", axis));
            disp("回應"+readline(obj.ser_xy));
            flush(obj.ser_xy);
            % Send the main message
            writeline(obj.ser_xy, message);
            disp("已發送給x:" + message);
            flush(obj.ser_xy);
            for i = 1:10
                res = readline(obj.ser_xy);
                if ~isempty(res)
                    response = res;
                    disp("x回應"+response);
                end
            end 
            
        end
        function response = send_y(obj,message)
            axis ="2";
            writeline(obj.ser_xy, sprintf("\\%s", axis));
            disp("回應"+readline(obj.ser_xy));
            flush(obj.ser_xy);
            % Send the main message
            writeline(obj.ser_xy, message);
            disp("已發送給y:" + message);
            flush(obj.ser_xy);
            for i = 1:10
                res = readline(obj.ser_xy);
                if ~isempty(res)
                    response = res;
                    disp("y回應"+response);
                end
            end  
            
        end
        function response = send_z(obj,message) 
            payload = ":01"+message;
            lrc = calculateLRCFromHex(payload);
            writeline(obj.ser_z, payload+lrc);
            disp("已發送給z:" + payload+lrc);
            response = readline(obj.ser_z);
            disp("z回應:" + response);
        end
        %%
        %%原點賦歸
        function response = home_x(obj)
            obj.move_x_ABS(200,100);
            response = obj.send_x("HOMECMD");
        end
        function response = home_y(obj)
            obj.move_y_ABS(200,100);
            response = obj.send_y("HOMECMD");
        end
        function response = home_z(obj) %,message
            payload = '06201E0003';
            response = obj.send_z(payload);
        end

        %%
        %%終止檢查
        function done = isXdone(obj)
            done = false;
            response = char(obj.send_x("STOPPED"));
            parts = split(response, '<');
            response = str2double(parts{1});
            if response>0
                done = true;
            end
            
        end
        function done = isYdone(obj)
            done = false;
            response = obj.send_y("STOPPED");
            parts = split(response, '<');
            response = str2double(parts{1});
            if response>0
                done = true;
            end
            
        end
        function done = isZdone(obj)
            response = obj.send_z("0310000001");
            done = strcmp(response,":0103020000FA");
            
        end
    end
end 
