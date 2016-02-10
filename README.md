# Eiwaji

eiwaji is a Japanese-to-English lexer and dictionary. It uses [mecab](http://taku910.github.io/mecab/) (with help from [ve](https://github.com/Kimtaro/ve)) to analyze Japanese sentences and allows for easy offline lookup of the parsed terms using [JMDict](http://www.edrdg.org/jmdict/j_jmdict.html).

<a href="https://raw.githubusercontent.com/Ruin0x11/eiwaji/master/img/linux.png"><img src="https://cloud.githubusercontent.com/assets/6700637/12964930/560a59da-d018-11e5-8d27-a3139da662b1.png" width="15%"></img></a>

## Features
* Lookup Japanese terms in English or other JMDict languages
* Separate Japanese text by part-of-speech and click a parsed term to lookup
* Capture clipboard to automatically analyze copied text

## Requirements
* Linux / OSX
* [libxml-ruby](https://github.com/xml4r/libxml-ruby) requirements (libm, zlib, libiconv, libxml2)
* [qtbindings](https://github.com/ryanmelt/qtbindings) requirements (Qt 4.8.x, cmake 2.8.x, gcc 4.x)
* mecab & mecab-ipadic

Tested on Ruby 2.2.3 & 2.2.4.

Does not build on Ruby 2.3.0 because of [this Ruby bug](https://bugs.ruby-lang.org/issues/11962) preventing the compilation of certain C++ extensions. If you install a separate Ruby version, it MUST be compiled with `--enable-shared`, or the application won't run. (If you're using ruby-build, this flag is [not set by default](https://github.com/rbenv/ruby-build/issues/35).)

## Installation
```
gem install eiwaji
```
Ensure that mecab and mecab-ipadic are installed before starting the program.
```
eiwaji
```

## License
BSD

## TODO
* Windows support / install instructions
* Study list creation / saving
* Reduce false negatives in lexer
