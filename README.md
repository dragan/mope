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
    * [2.1 Basic GitHub Checkout](#section_2.1)
      * [2.1.1 Upgrading](#section_2.1.1)
    * [2.2 Neckbeard Configuration](#section_2.2)
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
`~/.mope/versions/2.10.9/bin/csharp`.  mope makes _shim binaries_ for every such binary across 
all installed versions of Mono.

These shims are simple wrapper scripts that live in `~/.mope/shims` and detect which Mono version 
you want to use. They insert the directory for the selected version at the beginning of 
your `$PATH` and then execute the corresponding binary.

Because of the simplicity of the shim approach, all you need to use mope is `~/.mope/shims` 
in your `$PATH`.

## <a name="section_2"></a> 2 Installation

### <a name="section_2.1"></a> 2.1 Basic GitHub Checkout

This will get you going with the latest version of mope and make it 
easy to fork and contribute any changes back upstream.

1. Check out mope into `~/.mope`.

        $ cd
        $ git clone git://github.com/dragan/mope.git .mope

2. Add `~/.mope/bin` to your `$PATH` for access to the `mope` 
   command-line utility.

        $ echo 'export PATH="$HOME/.mope/bin:$PATH"' >> ~/.bash_profile

    **Zsh note**: Modify your `~/.zshenv` file instead of `~/.bash_profile`.

3. Add mope init to your shell to enable shims and autocompletion.

        $ echo 'eval "$(mope init -)"' >> ~/.bash_profile

    **Zsh note**: Modify your `~/.zshenv` file instead of `~/.bash_profile`.

4. Restart your shell so the path changes take effect. You can now 
   begin using mope.

        $ exec $SHELL

5. Install Mono versions into `~/.mope/versions`. For example, to 
   install Mono 2.11.0, download and unpack the source, then run:

        $ ./configure --prefix=$HOME/.mope/versions/2.11.0
        $ make
        $ make install

    The [mono-build](https://github.com/dragan/mono-build) project 
    provides a `mope install` command that simplifies the process of 
    installing new Mono versions to:

        $ mope install 2.11.0

6. Rebuild the shim binaries. You should do this any time you install 
   new Mono binary's (for example, when installing a new Mono version).

        $ mope rehash

    **note**:  `mope install` will automatically do this for you.

#### <a name="section_2.1.1"></a> 2.1.1 Upgrading

If you've installed mope using the instructions above, you can 
upgrade your installation at any time using git.

To upgrade to the latest development version of mope, use `git pull`:

    $ cd ~/.mope
    $ git pull

To upgrade to a specific release of mope, check out the corresponding 
tag:

    $ cd ~/.mope
    $ git fetch
    $ git tag
    v0.1.0
    v0.1.1
    v0.1.2
    v0.2.0
    $ git checkout v0.2.0

### <a name="section_2.2"></a> 2.2 Neckbeard Configuration

Skip this section unless you must know what every line in your shell 
profile is doing.

`mope init` is the only command that crosses the line of loading 
extra commands into your shell. Here's what `mope init` actually does:

1. Sets up your shims path. This is the only requirement for mope to 
   function properly. You can do this by hand by prepending 
   `~/.mope/shims` to your `$PATH`.

2. Installs autocompletion. This is entirely optional but pretty 
   useful. Sourcing `~/.mope/completions/mope.bash` will set that 
   up. There is also a `~/.mope/completions/mope.zsh` for Zsh 
   users.

3. Rehashes shims. From time to time you'll need to rebuild your 
   shim files. Doing this on init makes sure everything is up to 
   date. You can always run `mope rehash` manually.

4. Installs the sh dispatcher. This bit is also optional, but allows 
   mope and plugins to change variables in your current shell, making 
   commands like `mope shell` possible. The sh dispatcher doesn't do 
   anything crazy like override `cd` or hack your shell prompt, but if 
   for some reason you need `mope` to be a real script rather than a 
   shell function, you can safely skip it.

Run `mope init -` for yourself to see exactly what happens under the 
hood.

## <a name="section_3"></a> 3 Usage

Like `git`, the `mope` command delegates to subcommands based on its first argument. 
The most common subcommands are:

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