# Simple Mono Parallel Environment Manager: mope

mope lets you easily switch between multiple versions of Mono.  It's simple, unobtrusive, and follows 
the UNIX tradition of single-purpose tools that do one thing well.

<img src="http://cl.ragan.io/011j0w1W1B1T0Z010A1G/mope.png" width="859" height="718" />

## Features

### mope _does..._

* Let you **change the global Mono version** on a per-user basis.
* Provide support for **per-project Mono versions**.
* Allow you to **override the Mono version** with an environment variable.

### mope _does not..._

* **Need to be loaded into your shell.** Instead, mope's shim approach works by adding 
  a directory to your `$PATH`.
* **Override shell commands like `cd`.** That's dangerous and error-prone.
* **Have a configuration file.** There's nothing to configure except which version of 
  Mono you want to use.
* **Install Mono.** You can build and install Mono yourself, or use 
  [mono-build](https://github.com/dragan/mono-build) to automate the process.
* **Require changes to Mono libraries for compatibility.** The simplicity of mope means 
  as long as it's in your `$PATH`, nothing else needs to know about it.
* **Prompt you with warnings when you switch to a project.** Instead of executing arbitrary 
  code, mope reads just the version name from each project. There's nothing to "trust."

## Table of Contents

  * [1 How It Works](#section_1)
  * [2 Installation](#section_2)
  * [3 Usage](#section_3)
    * [3.1 mope global](#section_3.1)
    * [3.2 mope local](#section_3.2)
  * [4 Development](#section_4)
    * [4.1 Version History](#section_4.1)
    * [4.2 Thanks](#section_4.2)
    * [4.3 License](#section_4.3)

## <a name="section_1"></a> 1 How It Works

mope operates on the per-user directory `~/.mope`.  Version names in mope correspond 
to subdirectories of `~/.mope/versions`.  For example, you might have `~/.mope/versions/2.10.9` and 
`~/.mope/versions/2.11.0`.

Each version is a working tree with it's own binaries, like `~/.mope/versions/2.10.9/bin/mono` and 
`~/.mope/versions/2.10.9/bin/csharp`.

## <a name="section_2"></a> 2 Installation

## <a name="section_3"></a> 3 Usage

### <a name="section_3.1"></a> 3.1 mope global

Sets the global version of Mono to be used in all shells by writing
the version name to the `~/.mope/version` file. This version can be
overridden by a per-project `.mono-version` file, or by setting the
`MOPE_VERSION` environment variable.

    $ mope global 2.10.9

The special version name `system` tells mope to use the system Mono
(detected by searching your `$PATH`).

When run without a version number, `mope global` reports the
currently configured global version.

### <a name="section_3.2"></a> 3.2 mope local

Sets a local per-project Mono version by writing the version name to
a `.mono-version` file in the current directory. This version
overrides the global, and can be overridden itself by setting the
`MOPE_VERSION` environment variable.

    $ mope local 2.11.0

When run without a version number, `mope local` reports the currently
configured local version. You can also unset the local version:

    $ mope local --unset

## <a name="section_4"></a> 4 Development

### <a name="section_4.1"></a> 4.1 Version History

No releases yet.

### <a name="section_4.2"></a> 4.2 Thanks

This project was heavily inspired by the [rbenv](https://github.com/sstephenson/ruby-build) 
project by Sam Stephenson.

### <a name="section_4.3"></a> 4.3 License 

mope is released under the [MIT License][mit-license]. See LICENSE for more information.

[mit-license]: http://www.opensource.org/licenses/mit-license.php