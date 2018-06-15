# escape=`

FROM microsoft/windowsservercore-insider:10.0.17134.1

ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

# Install Build Tools excluding workloads and components with known issues.
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --includeOptional `
    || IF "%ERRORLEVEL%"=="3010" EXIT 0
   
SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

ENV chocolateyUseWindowsCompression=false

RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco install --yes python3 --params '"/InstallDir:C:\tools\python3"'

RUN python -m pip install --upgrade pip

RUN pip install win-unicode-console

RUN pip install conan conan_package_tools bincrafters_package_tools

RUN mkdir "C:\.conan"
 
WORKDIR "C:\Users\ContainerAdministrator"