module DbReporter
  class Document
    class Markdown
      def self.generate
        db_structure = DbReporter::Structure.new
        markdown = ""
        db_structure.each_table do |table|
          table_strs = []
          table_strs << "## #{table.name}"
          if table.comment
            table_strs << ""
            table_strs << "#{table.comment}"
          end
          table_strs << ""
          markdown += table_strs.join("\n") + "\n"
  
          # columns
          column_strs = []
          column_strs << "### Columns"
          column_strs << ""
          column_strs << "|Name|Comment|Type|Primary|Default|Null|Limit|Relation|"
          column_strs << "|---|---|---|---|---|---|---|---|"
          table.columns.each do |column|
            tmp = []
            tmp << column.name
            tmp << column.comment
            tmp << column.sql_type
            if column.primary_key.present?
              tmp << true
            else
              tmp << ''
            end
            if column.default == nil
              tmp << 'NULL'
            else
              tmp << column.default
            end
            tmp << column.null
            tmp << column.limit
            if column.foreign_key
              tmp << "[#{column.foreign_key[:to_table]}](##{column.foreign_key[:to_table]})"
            else
              tmp << ''
            end
  
            column_strs << "|"+tmp.join("|")+"|"
          end
          markdown += column_strs.join("\n") + "\n"
  
          # indexes
          index_strs = []
          if table.indexes
            markdown += "\n"
  
            index_strs << "### Indexes"
            index_strs << ""
            index_strs << "|Key|Columns|"
            index_strs << "|---|---|"
            index_strs += table.indexes.map{|k, c|"|#{[k, c.join(",")].join("|")}|"}
            markdown += index_strs.join("\n") + "\n"
            markdown += "\n"
          end
        end
        return markdown
      end
    end
  end
end
