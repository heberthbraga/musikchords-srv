unless defined? MONGO_CONFIG
  MONGO_CONFIG = YAML.load_file("#{Rails.root}/config/mongo.yml")[Rails.env] || {} rescue {}
end

MongoMapper.connection = Mongo::Connection.new(MONGO_CONFIG['host'], MONGO_CONFIG['port'] )
MongoMapper.database = MONGO_CONFIG['database']
if MONGO_CONFIG['user'] and MONGO_CONFIG['password']
  MongoMapper.database.authenticate(MONGO_CONFIG['user'], MONGO_CONFIG['password'])
end

if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     MongoMapper.connection.connect if forked
   end
end