require 'yaml'
require 'active_record'

module DbReporter
  class Structure
    def initialize(config_path: nil)
      @connection = connection(config_path: config_path)
    end

    def connection(config_path: nil)
      connection = nil
      rails_env = ENV['RAILS_ENV'] || 'development'

      if defined?(Rails)
        db_config = Rails.configuration.database_configuration[rails_env]
        connection = ActiveRecord::Base.establish_connection(db_config).connection
        config_path = Rails.root.join('config', 'database.yml')
      end

      unless connection
        begin
          yaml = YAML.load(File.read(config_path))
        rescue Psych::BadAlias
          # if Rails.version >= "6.1.0"
          yaml = ActiveSupport::ConfigurationFile.parse(config_path)
        rescue
          raise
        end
        config = yaml[rails_env]
        ec = ActiveRecord::Base.establish_connection(config)
        connection = ec.connection
      end
      connection
    end

    def each_table
      table_struct = Struct.new('Table', :name, :columns, :comment, :indexes)
      @connection.tables.each do |table_name|
        next if table_name == 'schema_migrations'
        next if table_name == 'ar_internal_metadata'
        ts = table_struct.new
        ts.name = table_name
        ts.comment = @connection.table_comment(table_name)
        ts.columns = columns(table_name)
        ts.indexes = @connection.indexes(table_name).each_with_object({}){|v, hash|hash[v.name] = v.columns}

        yield ts
      end
    end

    def column_struct
      @column_struct ||= Struct.new('Column', :name, :sql_type, :type, :primary_key, :foreign_key, :limit, :null, :default, :comment)
    end

    def columns(table_name)
      ret = []
      # current_database
      # encoding
      primary_key = @connection.primary_key(table_name)
      foreign_keys = @connection.foreign_keys(table_name).each_with_object({}){|k, hash|hash[k.options[:column]] = {to_table: k.to_table, name: k.options[:name]} if k.options[:column]}

      @connection.columns(table_name).each do |column|
        cs = column_struct.new
        cs.name = column.name
        cs.sql_type = column.sql_type_metadata.sql_type
        cs.type = column.sql_type_metadata.type

        cs.primary_key = primary_key == column.name
        if foreign_keys[column.name]
          cs.foreign_key = foreign_keys[column.name]
        end

        cs.limit = column.sql_type_metadata.limit
        cs.null = column.null
        cs.default = column.default
        cs.comment = column.comment
        ret << cs
      end
      ret
    end
  end
end
