require 'marloss'

module Choregraphie
  class DynamodbLock < Primitive
    def initialize(options = {}, &block)
      @options = Mash.new(options)

      validate!(:table, String)
      validate!(:hash_key, String)
      validate!(:id, String)

      @options[:create_table] ||= false
      @options[:ttl] ||= 30 # seconds
      @options[:backoff] ||= 5 # seconds

      # execute given block. can be used for Aws config
      yield if block_given?
    end

    def semaphore_class
      DynamodbSemaphore
    end

    def semaphore
      # this object cannot be reused after enter/exit
      semaphore_class.get_or_create(@options)
    end

    def backoff
      Chef::Log.warn "Will sleep #{@options[:backoff]}"
      sleep @options[:backoff]
      false # indicates failure
    end

    def wait_until(action, opts = {})
      Chef::Log.info "Will #{action} the lock #{@options[:id]}"
      success = 0.upto(opts[:max_failures] || Float::INFINITY).any? do |tries|
        begin
          yield || backoff
        rescue => e
          Chef::Log.warn "Error while #{action}-ing lock"
          Chef::Log.warn e
          backoff
        end
      end

      if success
        Chef::Log.info "#{action.to_s.capitalize}ed the lock #{@options[:id]}"
      else
        Chef::Log.warn "Will ignore errors and since we've reached #{opts[:max_failures]} errors"
      end
    end

    def register(choregraphie)

      choregraphie.before do
        wait_until(:enter) { semaphore.enter }
      end

      choregraphie.finish do
        # hack: We can ignore failure there since it is only to release
        # the lock. If there is a temporary failure, we can wait for the
        # next run to release the lock without compromising safety.
        # The reason we have to be a bit more relaxed here, is that all
        # chef run including a choregraphie with this primitive try to
        # release the lock at the end of a successful run
        wait_until(:exit, max_failures: 5) { semaphore.exit }
      end
    end
  end # class DynamodbLock

  class DynamodbSemaphore
    def self.get_or_create(opts)
      require 'marloss'
      retry_left = 5

      begin
        store = Marloss::Store.new(opts[:table], opts[:hash_key], ttl: opts[:ttl])
        store.create_table if opts[:create_table]
      rescue
        (retry_left -= 1) > 0 ? retry : raise
      end

      new(store, opts[:id])
    end

    def initialize(store, id)
      @locker = Marloss::Locker.new(store, id)
    end

    def enter
      @locker.obtain_lock
      Chef::Log.debug('Dynamodb Lock obtained')
      true
    rescue Marloss::LockNotObtainedError
      Chef::Log.debug('Dynamodb Lock not obtained. Will retry')
      false
    end

    def exit
      @locker.release_lock
      Chef::Log.debug('Dynamodb Lock released')
      true
    end
  end # class DynamodbSemaphore
end
