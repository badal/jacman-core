# jacman-core

## Description
  Command line only part of Jacinthe management tools, extracted from Jacman as a gem

## Version
  2.4

## Gems needed
* _jacman-utils
* _jacman-ip_
* _j2r_jaccess_ and _j2r-core_ for 'dashboard' method

## Synopsis
Can be used, either as a gem, or directly through three script tools.

## Usage : batch commands in _bin_ directory

  * `batman`  : batch manager for plain users (usual commands)
  * `cronman` : batch manager for cron daemon with reports in files
  * `jacdev`  : batch manager for developers (reserved commands).

Usage : `ruby batman <call_name>`, idem for `cronman` or `jacdev`.

## Usage : gem API

### class Core::Command

#### Attributes (read only)

* `call_name` : short call name
* `title` : title of command
* `help_text` : text to be shown in help dialog
* `proc` : Proc to be executed.

#### Instance methods

* `execute` : executes the command
* `cron_execute` : executes the command with output in files
* `stdout_file`, `stderr_file` : output files of `cron_execute`.

#### Class methods

* `Command.fetch(call_name)` : returns the Command
* `Command.cron_run(call_name)` : "cron executes" the Command.

### module Infos

#### Class method

* `Infos.report` returns an Array of items : `[value, caption]`.
* Example of item : `[3, 'fichiers clients en cours']`

### class CommandWatcher

#### Class method

`CommandWatcher.report[cmds, limit = 24]` where `cmds` is an Array of call_names and `limit` is a Numeric,
returns an Array of reports, each of which has the following form :

* if the last "cron execution" of the command was completed without error, `[tag, file, age]`
where file is the `stdout_file` and `age` is the age in hours of this file,
`tag` being `:OK` or `:LATE` according to whether `age` is `< limit` or not.

* if the last "cron execution" of the command had errors, `[:ERROR, file]`
  where file is the `stderr_file`.

* if the command was never "cron executed", `[:NEVER]`.

## Note
For commodity, gem contains sql_do_not_use directory with sql files

## More documentation
  * See the Yardoc/RDoc documentation.
  * See the html help file

  ![documentation](http://inch-ci.org/github/badal/jacman-core.svg?branch=master)

## Source and issues
   ![Code Climate](https://codeclimate.com/github/badal/jacman-core.png)

   Source code on repository [GitHub](https://github.com/badal/jacman-core)

## Copyright
  (c) 2014, Michel Demazure

## License
  ![License](http://img.shields.io/:license-mit-blue.svg)(http://doge.mit-license.org)

## Author
  Michel Demazure: michel at demazure dot com

