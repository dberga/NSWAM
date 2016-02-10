function [ ] = devlog( message, log_type )

if nargin < 2
    log_type = 0;
end

switch log_type
    case 0 %log message
        disp(['DEVLOG_MSG:' message]);
    case 1 %debug message
        disp(['DEVLOG_DEBUG:' message]);
    case 2 %dev message
        disp(['DEVLOG_DEV:' message]);
    case 3 %warning message
        disp(['DEVLOG_WARNING:' message]);
    case 4 %error message
        error(['DEVLOG_ERROR:' message]);

end

