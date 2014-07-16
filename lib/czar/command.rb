module Czar
  module Command

    def execute
      self.send self.state if self.respond_to? self.state
    end

    def result
      internal[:result]
    end

    def completed?
      state == :complete
    end

    def state
      @state ||= :start
    end

    def children
      @children ||= []
    end

    protected

    attr_accessor :parent

    def perform child_task
      child_task.parent = self
      children << child_task
      child_task.execute
    end

    def mark_as state, params = {}
      @state = state.to_sym
      @internal_state = params.dup
      notify_parent if @state == :complete
    end

    def internal
      @internal_state ||= {}
    end

    def notify_parent
      parent.child_task_completed self unless parent.nil?
    end

    def child_task_completed child_task

    end

  end
end
