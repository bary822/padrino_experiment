Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.db = case Padrino.env
  when :development then Sequel.connect("postgres://#{ENV['db_url']}/padrino_experiment_development", :loggers => [logger])
  when :production  then Sequel.connect("postgres://localhost/padrino_experiment_production",  :loggers => [logger])
  when :test        then Sequel.connect("postgres://localhost/padrino_experiment_test",        :loggers => [logger])
end
