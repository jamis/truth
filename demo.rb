require File.expand_path("../lib/truth.rb", __FILE__)

table = Truth::Table.new("A && B || C")
table.display
