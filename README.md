auto-close-OTBEdit
==================

auto-close-OTBEdit is a macro for [OTBEdit](http://www.hi-ho.ne.jp/a_ogawa/otbedit/).
This macro provides auto brancket closing.

Rules
-----

| Before | Input  | After |
|--------|--------|-------|
| \|     | (      | (\|)  |
| \|     | [      | [\|]  |
| \|     | {      | {\|}  |
| \|     | '      | '\|'  |
| \|     | "      | "\|"  |
| (\|)   | )      | ()\|  |
| [\|]   | ]      | []\|  |
| {\|}   | }      | {}\|  |
| '\|'   | '      | ''\|  |
| "\|"   | "      | ""\|  |
| (\|)   | \<BS\> | \|    |
| [\|]   | \<BS\> | \|    |
| {\|}   | \<BS\> | \|    |
| '\|'   | \<BS\> | \|    |
| "\|"   | \<BS\> | \|    |

(Cursor is in |)

Installation
------------

1. download autoclose-otbedit.zip from the [releases page](https://github.com/nil2nekoni/auto-close-otbedit/releases)

2. Unpack the zip file, and put all in your OTBEdit directory.

3. Write in otbedit.scm in scmlib directory.

```scm
(use auto-close)
```

(Please create if otbedit.scm doesn't exist in scmlib directory)

License
-------

MIT License

Author
------

nil2 <nil2@nil2.org>
