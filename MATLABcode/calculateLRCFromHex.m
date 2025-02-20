% lrc
function lrc = calculateLRCFromHex(hex_str)
    %hex_str = ':0106201E0003'; % 字符串
    hex_str = char(erase(hex_str,':'));
    byte_array =[];
    for i = 1:2:strlength(hex_str)      
        byte_array =[byte_array ,hex2dec(hex_str(1,i:i+1))];
    end
    % 初始化 LRC
    lrc = 0;
    % 累加所有字節並取低 8 位
    for byte = byte_array
        lrc = bitand(lrc + byte, 255); % 等效於 & 0xFF
    end
    % 計算二補數並取低 8 位
    lrc = bitand(bitcmp(lrc,"uint8") + 1, 255); % 等效於 (~lrc + 1) & 0xFF
    lrc = dec2hex(lrc, 2);
end