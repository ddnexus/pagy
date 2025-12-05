# frozen_string_literal: true

require 'sqlite3'

Minitest.after_run do
  # Ensure Pagy::ROOT is available (main lib must be loaded first)
  db_path = Pagy::ROOT.join('../test/files/db/test.sqlite3')

  if File.exist?(db_path)
    begin
      db = SQLite3::Database.new(db_path)
      db.execute('PRAGMA wal_checkpoint(TRUNCATE);')
      db.close
    rescue SQLite3::Exception => e
      puts "Error during WAL checkpoint: #{e.message}"
    end
  else
    puts "#{db_path} does not exist"
  end
end
