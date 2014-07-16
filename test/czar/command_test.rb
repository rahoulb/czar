require_relative '../../lib/czar/command'
require 'minitest/autorun'
require 'mocha/setup'

describe Czar::Command do

  describe "initialisation" do
    subject { initialiser.new }

    it "is ready to start" do
      subject.state.must_equal :start
    end

    let(:initialiser) do
      Class.new do
        include Czar::Command
      end
    end
  end

  describe "performing a one stage task" do
    subject { one_stage_task.new }

    it "executes the start task" do
      subject.execute

      subject.completed?.must_equal true
      subject.result.must_equal "DONE"
    end

    let(:one_stage_task) do
      Class.new do
        include Czar::Command

        def start
          mark_as :complete, result: "DONE"
        end
      end
    end
  end

  describe "performing a multi stage task" do
    subject { multi_stage_task.new }

    it "executes the tasks and moves through the states in order" do
      subject.execute
      subject.state.must_equal :in_progress

      subject.execute
      subject.state.must_equal :having_a_rest

      subject.execute
      subject.state.must_equal :having_a_rest

      subject.execute
      subject.completed?.must_equal true
      subject.result.must_equal 'Goodbye'
    end

    let(:multi_stage_task) do
      Class.new do
        include Czar::Command

        def start
          mark_as :in_progress
        end

        def in_progress
          mark_as :having_a_rest, counter: 1
        end

        def having_a_rest
          if internal[:counter] == 1 
            mark_as :having_a_rest, counter: 2
          else
            mark_as :complete, result: 'Goodbye'
          end
        end
      end
    end
  end

  describe "having states that do nothing" do
    subject { do_nothing_task.new }

    it "executes the first task and then does nothing" do
      subject.execute
      subject.state.must_equal :idle
      subject.execute
      subject.state.must_equal :idle
    end

    let(:do_nothing_task) do
      Class.new do
        include Czar::Command

        def start
          mark_as :idle
        end
      end
    end
  end

  describe "triggering child commands" do
    subject { parent_task.new }

    it "starts the child command and is not marked as complete until both it and the child have completed" do
      subject.execute

      child = subject.children.first
      child.state.must_equal :in_progress
      subject.state.must_equal :waiting_for_child_to_complete
      subject.completed?.wont_equal true

      child.execute
      child.completed?.must_equal true
      subject.completed?.must_equal true
    end

    let(:parent_task) do
      Class.new do
        include Czar::Command

        def start
          perform ChildTask.new
          mark_as :waiting_for_child_to_complete
        end

        def child_task_completed child_task
          mark_as :complete
        end

        class ChildTask
          include Czar::Command

          def start
            mark_as :in_progress
          end

          def in_progress
            mark_as :complete
          end
        end
      end
    end
  end
end
