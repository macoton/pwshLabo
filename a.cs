using System;
using System.Runtime.InteropServices;

public class MemoryMappedFile
{
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr OpenFileMapping(
        uint dwDesiredAccess,
        bool bInheritHandle,
        string lpName
    );

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr CreateFileMapping(
        IntPtr hFile,
        IntPtr lpFileMappingAttributes,
        uint flProtect,
        uint dwMaximumSizeHigh,
        uint dwMaximumSizeLow,
        string lpName
    );

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr MapViewOfFile(
        IntPtr hFileMappingObject,
        uint dwDesiredAccess,
        uint dwFileOffsetHigh,
        uint dwFileOffsetLow,
        uint dwNumberOfBytesToMap
    );

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool UnmapViewOfFile(IntPtr lpBaseAddress);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool CloseHandle(IntPtr hObject);
}
