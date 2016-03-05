all: ui_dictionary_dock.rb ui_lexer.rb ui_main_window.rb ui_settings.rb ui_vocab_list.rb

clean:
	rm ui_*.rb

ui_dictionary_dock.rb: dictionary_dock.ui
	rbuic4 dictionary_dock.ui -o ui_dictionary_dock.rb
ui_lexer.rb: lexer.ui
	rbuic4 lexer.ui -o ui_lexer.rb
ui_main_window.rb: main_window.ui
	rbuic4 main_window.ui -o ui_main_window.rb
ui_settings.rb: settings.ui
	rbuic4 settings.ui -o ui_settings.rb
ui_vocab_list.rb: vocab_list.ui
	rbuic4 vocab_list.ui -o ui_vocab_list.rb
