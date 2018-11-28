# Task testing support methods provided by rails-testing-toolbox
# Src: https://github.com/eliotsykes/rails-testing-toolbox/blob/master/tasks.rb

# Task names should be used in the top-level describe, with an optional
# "rake "-prefix for better documentation. Both of these will work:
#
# 1) describe 'foo:bar' do ... end
#
# 2) describe 'rake foo:bar' do ... end
#
# Favor including 'rake '-prefix as in the 2nd example above as it produces
# doc output that makes it clear a rake task is under test and how it is
# invoked.

require "rake"
require 'active_support/concern'

module TaskExampleGroup
  extend ActiveSupport::Concern

  included do
    # Removes 'rake' from the test's describe string, and labels it 'task_name'
    let(:task_name) { self.class.top_level_description.sub(/\Arake /, "") }
    let(:tasks) { Rake::Task }

    # Sets subject to "Rake::Task[namespace::task_name]" with 'task' label
    # Allows easy use with shoulda-matchers or conventional expectation syntax
    subject(:task) { tasks[task_name] }
  end
end


RSpec.configure do |config|
  config.define_derived_metadata(:file_path => %r{/spec/tasks/}) do |metadata|
    metadata[:type] = :task
  end

  # For 'type: :task' tests, includes the above module
  config.include TaskExampleGroup, type: :task

  config.before(:suite) do
    Rails.application.load_tasks
  end
end
