
#include <iostream>
#include <Python.h>

int main(int argc, char* argv[])
{
    Py_SetProgramName((char*)"embeddedPython");
    Py_Initialize();
    PyRun_SimpleString((char*)"\
from pxr import Glf\n\
help(Glf)\n\
");
    Py_Finalize();
}
