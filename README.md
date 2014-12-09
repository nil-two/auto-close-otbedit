auto-close-otbedit
==================
autoclose-otbedit is a macro for [OTBEdit](http://www.hi-ho.ne.jp/a_ogawa/otbedit/).
This macro provides auto brancket closing

Usage
====================
1. Start OTBEdit.

2. Input (.

```
(|)
```
(Cursor is in |)

Installation
====================
1. download autoclose-otbedit.zip from the [releases page](https://github.com/kusabashira/autoclose-otbedit/releases)

2. Unpack the zip file, and put all in your OTBEdit directory.

3. Write in otbedit.scm in scmlib directory.

```scm
(use autoclose)
```
(Please create if otbedit.scm doesn't exist in scmlib directory)

License
====================
MIT License

Author
====================
wara <kusabashira227@gmail.com>
