# Simple Mono Parallel Environment Manager: mope

mope lets you easily switch between multiple versions of Mono.  It's simple, unobtrusive, and follows the UNIX tradition of single-purpose tools that do one thing well.

## Table of Contents

    * [1 How It Works](#section_1)

## <a name="section_1"></a> 1 How It Works

mope operates on the per-user directory `~/.mope`.  Version names in mope correspond to subdirectories of `~/.mope/versions`.  For example, you might have `~/.mope/versions/2.10.9` and `~/.mope/versions/2.11.0`.

Each version is a working tree with it's own binaries, like `~/.mope/versions/2.10.9/bin/mono` and `~/.mope/versions/2.10.9/bin/csharp`.

## Thanks

This project was heavily inspired by the [rbenv](https://github.com/sstephenson/ruby-build) by Sam Stephenson. 

## License
mono-build is released under the [MIT License][mit-license]. See LICENSE for more information.

[mit-license]: http://www.opensource.org/licenses/mit-license.php