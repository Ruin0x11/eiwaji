require_relative 'eiwaji/version'

module Eiwaji
  module Constants

    if Eiwaji::DEBUG
      BASE_PATH ||= ENV["HOME"]
    else
      BASE_PATH ||= File.join(File.dirname(File.expand_path(__FILE__)), '..')
    end

    CONFIG_PATH     ||= File.join(BASE_PATH, "eiwajirc")
    DICTIONARY_PATH ||= File.join(BASE_PATH, "dicts")
    INDEX_FILE      ||= File.join(DICTIONARY_PATH, "fts5.db")

    WINDOW_WIDTH    ||= 1024
    WINDOW_HEIGHT   ||= 768

  end
end
