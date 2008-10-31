
module ActiveRecord
  module Acts #:nodoc:
    module SeoFriendly #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module MigrationMethods
        def create_seo_friendly_column()
          seo_column_name = read_inheritable_attribute(:seo_friendly_options)[:seo_friendly_id_field].to_s
          seo_column_limit = read_inheritable_attribute(:seo_friendly_options)[:seo_friendly_id_limit].to_i
          self.connection.add_column table_name(), seo_column_name, :string, :null => true, :limit => seo_column_limit
          self.connection.add_index table_name(), seo_column_name, :unique => true
        end
        
        def drop_seo_friendly_column()
          seo_column_name = read_inheritable_attribute(:seo_friendly_options)[:seo_friendly_id_field].to_s
          self.connection.remove_index table_name(), seo_column_name
          self.connection.remove_column table_name(), seo_column_name
        end
      end

      module ClassMethods
        #
        # Use find_by_seo_friendly_id
        def acts_as_seo_friendly(options = {})
          options = {:seo_friendly_id_field => :seo_friendly_id, :seo_friendly_id_limit => 50}.merge(options)
          write_inheritable_attribute(:seo_friendly_options, options)
          
          after_save :create_seo_friendly_id
          to_param_with(read_inheritable_attribute(:seo_friendly_options)[:seo_friendly_id_field])
          
          if !self.included_modules.include?(ActiveRecord::Acts::SeoFriendly::InstanceMethods)
            include ActiveRecord::Acts::SeoFriendly::InstanceMethods
          end
        end
        
        include ActiveRecord::Acts::SeoFriendly::MigrationMethods
        
        private
        def to_param_with(attr_sym)
          return if attr_sym.nil?
          attr_str = attr_sym.to_s
          class_eval <<-EOS
            def to_param
              (#{attr_str} = self.#{attr_str}) ? #{attr_str} : nil
            end
          EOS
        end
      end
      
      
      module InstanceMethods
        private        
        
        INITITAL_SEO_UNIQUE_DIGITS = 4         # initially allow for 1000 collisions.. 
        
        def create_seo_friendly_id
          ## return if there are errors
          return if self.errors.length > 0
          
          seo_id_field = self.class.read_inheritable_attribute(:seo_friendly_options)[:seo_friendly_id_field].to_s
          count_seo_id_field = "count_#{seo_id_field}"
          count_seo_id_field_N = "#{count_seo_id_field}_N"
                    
          resource_id_field = self.class.read_inheritable_attribute(:seo_friendly_options)[:resource_id].to_s
          resource_id_value = self[resource_id_field]
          
          return if resource_id_value.blank?
          
          seo_id_value = create_seo_friendly_str(resource_id_value)

          return if (self[seo_id_field] =~ /^#{seo_id_value}$/) || (self[seo_id_field] =~ /^#{seo_id_value}\-\d+$/)

          self.class.transaction do
            unique_id = determine_unique_id(seo_id_field, count_seo_id_field, count_seo_id_field_N, seo_id_value)
            seo_field_value = "#{seo_id_value}" + (unique_id != nil ? "-#{unique_id}" : "")
            
            seo_friendly_id_limit = self.class.read_inheritable_attribute(:seo_friendly_options)[:seo_friendly_id_limit].to_i
            
            if seo_field_value.size > seo_friendly_id_limit
              seo_id_value = create_seo_friendly_str(resource_id_value, INITITAL_SEO_UNIQUE_DIGITS + (seo_field_value.size - seo_friendly_id_limit))
              unique_id = determine_unique_id(seo_id_field, count_seo_id_field, count_seo_id_field_N, seo_id_value)

              seo_field_value = "#{seo_id_value}" + (unique_id != nil ? "-#{unique_id}" : "")
              seo_field_value = self['id'] if seo_field_value.size > seo_friendly_id_limit # still doesn't fit..give up, store the id
            end

            self.class.update_all("#{seo_id_field} = \'#{seo_field_value}\'", ["id = ?", self.id])
            # set it so that it can be used after this..
            self[seo_id_field] = seo_field_value
          end
          
          true
        end
        
        
        def determine_unique_id(seo_id_field, count_seo_id_field, count_seo_id_field_N, seo_id_value)
          conditions_proc = self.class.read_inheritable_attribute(:seo_friendly_options)[:conditions]
          conditions_option = execute_block(conditions_proc)
          conditions = (!conditions_option.blank? ? " AND #{self.class.send(:sanitize_sql, conditions_option)} " : "")
          
          counts = self.class.find_by_sql(%Q(
            select count(#{seo_id_field}) as #{count_seo_id_field}, NULL as #{count_seo_id_field_N} from #{self.class.table_name} where #{seo_id_field} = '#{seo_id_value}' #{conditions}
            UNION 
            select NULL as #{count_seo_id_field}, count(#{seo_id_field}) as #{count_seo_id_field_N} from #{self.class.table_name} where #{seo_id_field} like '#{seo_id_value}-%' #{conditions};)
          )

          # can't guarantee order of results
          count_seo_id_value = counts[0][count_seo_id_field].to_i
          if counts[0][count_seo_id_field].nil?
            count_seo_id_value = counts[1][count_seo_id_field].to_i
          end
          
          count_seo_id_N_value = counts[0][count_seo_id_field_N].to_i
          if counts[0][count_seo_id_field_N].nil?
            count_seo_id_N_value = counts[1][count_seo_id_field_N].to_i
          end
          
          result = nil
          if (count_seo_id_value != 0)
            result = count_seo_id_N_value + 1
            result += 1 until self.class.send("find_by_#{seo_id_field}".to_sym, "#{seo_id_value}-#{result}").blank?
          end
          return result
        end
        
        def create_seo_friendly_str(str, digits = INITITAL_SEO_UNIQUE_DIGITS)
          s = str.dup
          s.gsub!(/\'/, '')
          s.gsub!(/\W+/, ' ')
          s.strip!
          s.downcase!
          s.gsub!(/\ +/, '-')
          s.gsub!(/\-{2}/, '-')
          limit = self.class.read_inheritable_attribute(:seo_friendly_options)[:seo_friendly_id_limit].to_i - digits
          # if we are trimming on a word, attempt to pretty it up and trim on a boundary (if available)
          if s.length > limit && (s[limit, 1] =~ /[^\-]{1}/) != nil && (last_boundary_index = s[0..(limit - 1)].rindex('-')) != nil
            limit = last_boundary_index
          end
          s = s[0..(limit - 1)]
          ## final check to make sure no trailing -'s
          s.gsub!(/\-$/,'')
          return s
        end
        
        # Given a piece of code, this method calls send(code) if code is a symbol, code.call(self) if it is callable
        # or simply executes it
        def execute_block(block)
          case
            when block.is_a?(Symbol)
              send(block)
            when block.respond_to?(:call) && (block.arity == 1 || block.arity == -1)
              block.call(self)
            else
              block
            end  
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::SeoFriendly)
