# Eiwaji

eiwaji is a Japanese-to-English lexer and dictionary. It uses [mecab](http://taku910.github.io/mecab/) (with help from [ve](https://github.com/Kimtaro/ve)) to analyze Japanese sentences and allows for easy offline lookup of the parsed terms using [JMDict](http://www.edrdg.org/jmdict/j_jmdict.html).

## Requirements
* Linux / OSX
* Qt 4.8.x
* cmake 2.8.x
* gcc 4.x
* mecab & mecab-ipadic

See [qtbindings](https://github.com/ryanmelt/qtbindings) for additional information on the Ruby Qt bindings.

Tested on Ruby 2.2.3 & 2.2.4.

Does not compile on Ruby 2.3.0 because of [this Ruby bug](https://bugs.ruby-lang.org/issues/11962) preventing the compilation of certain C++ extensions. If you install a separate Ruby version, it MUST be compiled with `--enable-shared`.

## Installation
```
gem install eiwaji

eiwaji
```

## License
BSD.

## TODO
* Windows support / install instructions
* Study list creation / saving
* Reduce false negatives in lexer
