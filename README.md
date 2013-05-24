Folders must be present at NASTestScript directory:

Apps
Content
Logs
Results
Temp

-------

Apps for this script can be downloaded from here:


http://yadi.sk/d/ZWGyXzxE58OXU (NASPT.zip)

http://yadi.sk/d/JMmTzuOD58OZI (iometer.zip)

http://yadi.sk/d/lydS8w7O58Oaa (curl.zip)

Also you can use standart application Nas Performance Tool 1.7.1, Curl for windows (32 bit) and iometer 1.1.0 or older instead of apps from my hosting.

Install of apps -

curl.rar extract to /curl

iometer.zip extract to /iometer
also in Apps dir must be? present iometer_SAMBA_default.icf (http://yadi.sk/d/6t5XTqMH58OoG)

naspt.zip install setup.exe, then copy msvcr71.dll (http://yadi.sk/d/CyeKjwbg58OtE) to %windir%\system (or system32) folder 


In Content folder must be present folder Test, where must be folders and files for FileCopy test
In this dir must be two files - HTTPUpDo.rar and UpDo.rar
This files transfers to NAS while Http/FTP testing.


-------

In future i`ll clean this problems