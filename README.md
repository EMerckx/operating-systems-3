# operating-systems-3

This is the repository for the course Operating Systems 3 that I take at UGent.

The assignments are in Dutch but the code will be in English.

## Easy access

### Command Prompt

A batch file can be created to ease the access to the directory in Windows. First create the batch file with the name ```gotoOS3.bat```. Next, click with the right mouse button on the file and choose Edit. Copy paste the following code into the file.

```
@ECHO OFF
CD /D "<absolute path to the directory>"
CMD
```

Now you can just double click the batch file and you're located in the directory.

### Powershell

The same can be achieved with Windows Powershell. You just need to edit the batch file. The last command lets you run script files.

```
@ECHO OFF
CD /D "<absolute path to the directory>"
powershell
Set-ExecutionPolicy RemoteSigned
```

## WMI CIM Studio

### Installation

For installing the WMI CIM Studio, I used the following download link: [Microsoft CIM][1]

After the installation, upon opening the CIM Studio I couldn't connect to the namespace. I fixed this issue using an [answer on Stack Overflow][2]. The solution is adding the following line in the HEAD of the Html file, just before the SCRIPT tag.

```
<meta http-equiv="X-UA-Compatible" content="IE=8" />
```

### View object qualifiers

To view the qualifiers of the class, click with your right mouse button on the grid of the Properties tab. There you can click on the Object Qualifiers button and a window pops up. In this window, all the qualifiers are present.

## Windows PowerShell ISE

If PowerShell ISE isn't present on your system, you can follow the following [guide][3]. To install it you just have to open a PowerShell window and invoke the following commands. Afterwards, you can run the PowerShell ISE from Start. 

```
Import-Module ServerManager 
Add-WindowsFeature PowerShell-ISE
```

[1]: https://www.microsoft.com/en-us/download/details.aspx?id=24045
[2]: http://stackoverflow.com/a/25455243/3149157
[3]: https://blogs.msdn.microsoft.com/guruketepalli/2012/11/06/enable-powershell-ise-from-windows-server-2008-r2/
