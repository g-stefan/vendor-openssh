// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022-2024 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

Fabricare.include("vendor");

messageAction("make");

if (Shell.fileExists("temp/build.done.flag")) {
	return;
};

if (!Shell.directoryExists("source")) {
	exitIf(Shell.system("7z x -aoa archive/" + Project.vendor + ".7z"));
	Shell.rename(Project.vendor, "source");
};

Shell.mkdirRecursivelyIfNotExists("output");
Shell.mkdirRecursivelyIfNotExists("temp");

var outputPath = Shell.getcwd() + "\\output";

var buildPlatform;
var buildPath;

if (Platform.name.indexOf("win32") >= 0) {
	buildPlatform = "x86";
	buildPath = "Win32";
} else {
	buildPlatform = "x64";
	buildPath = "x64";
};

runInPath("source/contrib/win32/openssh", function() {
	exitIf(Shell.system("msbuild /property:Configuration=Release /property:Platform=" + buildPlatform + " /target:Build Win32-OpenSSH.sln -maxcpucount"));
});

Shell.copyFilesToDirectory("source/bin/" + buildPath + "/Release/*.exe", "output");
Shell.copyFilesToDirectory("source/bin/" + buildPath + "/Release/*.ps1", "output");
Shell.copyFilesToDirectory("source/bin/" + buildPath + "/Release/OpenSSHUtils.*", "output");

Shell.copyFile("source/bin/" + buildPath + "/Release/Openssh-events.man", "output/Openssh-events.man");
Shell.copyFile("source/bin/" + buildPath + "/Release/sshd_config_default", "output/sshd_config_default");
Shell.copyFile("source/contrib/win32/openssh/LibreSSL/bin/desktop/" + buildPlatform + "/libcrypto.dll", "output/libcrypto.dll");
Shell.copyFile("source/contrib/win32/openssh/install-sshd.ps1", "output/install-sshd.ps1");
Shell.copyFile("source/contrib/win32/openssh/uninstall-sshd.ps1", "output/uninstall-sshd.ps1");
Shell.copyFile("source/contrib/win32/openssh/FixHostFilePermissions.ps1", "output/FixHostFilePermissions.ps1");
Shell.copyFile("source/contrib/win32/openssh/FixUserFilePermissions.ps1", "output/FixUserFilePermissions.ps1");
Shell.copyFile("source/LICENCE", "output/LICENSE");
Shell.copyFile("fabricare/source/OpenSSHUtils.psm1", "output/OpenSSHUtils.psm1");

Shell.mkdirRecursivelyIfNotExists("temp");
Shell.filePutContents("temp/build.done.flag", "done");
