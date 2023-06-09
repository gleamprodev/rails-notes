require 'rails'
require 'action_controller'
require 'rails-footnotes/abstract_note'
require 'rails-footnotes/each_with_rescue'
require 'rails-footnotes/filter'
require 'rails-footnotes/notes/all'
require 'rails-footnotes/extension'

module Footnotes
  mattr_accessor :before_hooks
  @@before_hooks = []

  mattr_accessor :after_hooks
  @@after_hooks = []

  mattr_accessor :enabled
  @@enabled = false

  class << self
    delegate :notes, :to => Filter
    delegate :notes=, :to => Filter

    delegate :prefix, :to => Filter
    delegate :prefix=, :to => Filter

    delegate :no_style, :to => Filter
    delegate :no_style=, :to => Filter

    delegate :multiple_notes, :to => Filter
    delegate :multiple_notes=, :to => Filter

    delegate :lock_top_right, :to => Filter
    delegate :lock_top_right=, :to => Filter

    delegate :font_size, :to => Filter
    delegate :font_size=, :to => Filter
  end

  def self.before(&block)
    @@before_hooks << block
  end

  def self.after(&block)
    @@after_hooks << block
  end

  def self.enabled?(controller)
    if @@enabled.is_a? Proc
      if @@enabled.arity == 1
        @@enabled.call(controller)
      else
        @@enabled.call
      end
    else
      !!@@enabled
    end
  end

  def self.setup
    yield self
  end
end

ActiveSupport.on_load(:action_controller) do
  ActionController::Base.send(:include, Footnotes::RailsFootnotesExtension)
end

load Rails.root.join('.rails_footnotes') if Rails.root && Rails.root.join('.rails_footnotes').exist?
