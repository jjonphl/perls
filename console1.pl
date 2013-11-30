#! perl win32

use Win32::Console;

$con = new Win32::Console(STD_OUTPUT_HANDLE);
$con->Cls();
$con->FillChar('-', 79, 0, 0);

$inp = new Win32::Console(STD_INPUT_HANDLE);
@info = $con->Info();
print $info[0] . $info[1];