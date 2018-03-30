require 'best_type/version'
require 'best_type/config'
require 'best_type/mime_type_lookup'
require 'best_type/dc_type_lookup'
require 'yaml'

module BestType
  @semaphore = Mutex.new

  def self.mime_type
    @mime_type ||= BestType::MimeTypeLookup.new(config)
  end

  def self.dc_type
    @dc_type ||= BestType::DcTypeLookup.new(mime_type)
  end

  def self.config(reload = false, user_config_options = {})
    if @config.nil? || reload
      @semaphore.synchronize do
        @config = BestType::Config.new(user_config_options)
        @mime_type = nil
        @dc_type = nil
      end
    end
    @config
  end

  def self.configure(opts = {})
    config(true, opts)
  end

end
