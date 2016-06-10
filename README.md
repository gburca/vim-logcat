# Android LogCat Syntax/FTDetect

This is a vim syntax file for Android LogCat log files. The log files must be
in the 'time' format: `adb logcat -v time *:V`

The `filetype` will be set to `logcat` for `*.lc` or `*.logcat` files or
if the second file line is similar to the example below (the 1st line may not
be a log entry, so that's why it's ignored).

A typical log entry is expected to look like this:

```
06-09 14:36:00.000 V/AlarmManager( 1484): sending alarm {957ff72 type 3 *alarm*:android.intent.action.TIME_TICK}
06-09 10:42:06.729 I/chatty  ( 1484): uid=1000(system) Binder:1484_5 expire 1 line
```

The highlighting may be customized from `~/.vimrc` by adding tags to highlight
to the myTags group, and words to highlight to the myKeywords group. For
example, this would highlight "BatteryService" or "StatsUtilsManager" if they
appear in the log tag, and "success" if it appears in the log message.

```
autocmd BufReadPost * if exists("b:current_syntax") && b:current_syntax == "logcat"
autocmd BufReadPost *     syn keyword myTags BatteryService StatsUtilsManager
autocmd BufReadPost *     syn keyword myKeywords success
autocmd BufReadPost * endif
```

# TODO

Handle log files in formats other than 'time' (ex: brief, process, tag,
threadtime, etc...).
