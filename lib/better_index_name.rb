# frozen_string_literal: true

require_relative "better_index_name/version"
require "active_record/connection_adapters/abstract/schema_statements"

module BetterIndexName
  def index_name(table_name, options) 
    if Hash === options
      if options[:column]
        name = "index_#{table_name}_on_#{Array(options[:column]) * '_and_'}"
        compress_index_name(name)
      elsif options[:name]
        options[:name]
      else
        raise ArgumentError, "You must specify the index name"
      end
    else
      index_name(table_name, index_name_options(options))
    end
  end

  ## Smarter version of compress_index_name 
  ##   Make index names fit DB constraints via a series of steps
  ## 1. change polymorphic references to just the name of the relation
  ## 2. change 'index_' to 'ix_'
  ## 3. remove common strings from column names
  ## 4. remove leading parts of the table name until there's only one
  ## 5. change the columnn names used in the index to a hash
  ## 6. change the table name to a hash if shorter
  ## The end.  If it's still too long, you'll have to name it manually
  def compress_index_name(name)
    method_index = 0
    new_name = name
    while new_name.length > 63 && method_index >= 0
      # ap "[#{method_index}] #{new_name}"
      case method_index
      when 0
        # change polymorphic index to just name
        table_part, column_part = new_name.split('_on_')
        columns = column_part.split('_and_')
        polys = columns.select{|e| e.include?('_type') && columns.include?(e.sub('_type','_id')) }
        if polys.any?
          polys.each do |poly|
            poly = poly.split('_').first
            columns[columns.index("#{poly}_type")] = poly
            columns.delete("#{poly}_id")
          end
          new_name = "#{table_part}_on_#{columns.join("_and_")}"
        end
        method_index += 1
      when 1
        # change index to idx
        new_name = name.sub("index_","ix_")
        method_index += 1
      when 2
        # remove common strings from column names
        column_part = new_name.split('_on_').last
        columns = column_part.split('_and_')
        if columns.size > 1 && (common_str = longest_common_substr(columns))
          common_str = common_str.sub(/_at|_id/,'')
          if common_str.size > 2
            ap "common_str: #{common_str}"
            new_name = new_name.gsub(common_str, '')
          end
        end
        method_index += 1
      when 3
        # remove the leading parts of the table name
        table_name = new_name.match(/ix_(.*)_on.*/)[1]
        parts = table_name.split('_')
        if parts.size > 1
          parts.shift
          new_table_name = parts.join('_')
          new_name = new_name.sub("ix_#{table_name}_on","ix_#{new_table_name}_on")
        else
          method_index += 1
        end
      when 4
        # hash the columns used in the index
        columns = new_name.split('_on_').last
        hash = Digest::MD5.base64digest(columns)[0..-3]
        new_name = new_name.sub(columns, hash) 
        method_index += 1
      when 5
        # change table name to hash
        table_name = new_name.match(/ix_(.*)_on.*/)[1]
        hash = Digest::MD5.base64digest(table_name)[0..-3]
        if table_name.size > hash.size
          new_name = new_name.sub(table_name, hash)
        end
        method_index += 1
      else
        method_index = -99
      end
    end
    new_name
  end

  def longest_common_substr(strings)
    shortest = strings.min_by(&:length)
    maxlen = shortest.length
    maxlen.downto(0) do |len|
      0.upto(maxlen - len) do |start|
        substr = shortest[start,len]
        return substr if strings.all?{|str| str.include?(substr) }
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::SchemaStatements.send(:include, BetterIndexName)