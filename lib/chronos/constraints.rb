require 'json'

module Chronos
  class Constraints
    class << self
      def generate_constraints_id
        SecureRandom.uuid
      end

      def get(id)
        path = constraints_path(id)
        data = File.read(path)
        JSON.parse(data, symbolize_names: true)
      rescue Errno::ENOENT => e
        [{error: e.message}]
      end

      def put(id, constraints)
        path = constraints_path(id)
        File.open(path, 'w') do |file|
          file.write(JSON.dump(constraints))
          file
        end
      end

      def destroy(id)
        path = constraints_path(id)
        File.delete(path) if File.exist? path
      end

      def get_all(ids)
        ids.reduce([]) { |memo, id| memo | get(id) }
      end

      private

      def constraints_path(id)
        file_name = "#{id}.json"
        [Chronos.configuration.data_path, file_name].join('/')
      end
    end # class methods
  end
end
