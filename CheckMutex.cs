using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace MUTEX
{
    public class Win32Calls
    {

        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern IntPtr CreateMutex(IntPtr lpMutexAttributes,
            bool bInitialOwner, string lpName);

        [DllImport("kernel32.dll")]
        public static extern bool ReleaseMutex(IntPtr hMutex);

        public const int ERROR_ALREADY_EXISTS = 183;

    }

    class Program
    {
        static int Main(string[] args)
        {
            if (args.Length == 0)
            {
                System.Console.WriteLine("Please enter a Mutex name to check");
                return -1;
            }
            string sMutex = Convert.ToString(args[0]);
            IntPtr ipMutexAttr = new IntPtr(0);
            IntPtr ipHMutex = new IntPtr(0);
            ipHMutex = Win32Calls.CreateMutex(ipMutexAttr,
                    true, sMutex);

            if (ipHMutex != (IntPtr)0)
            {
                int iGLE = Marshal.GetLastWin32Error();
                if (iGLE == Win32Calls.ERROR_ALREADY_EXISTS)
                {
                    Console.WriteLine("Mutex found!");
                    return 1;
                }
                else
                {
                    Console.Write("Not Found");
                    return 0;
                }
            }
            else
            {
                Console.WriteLine("Error during operation...");
                return -1;
            }
        }
    }
}
