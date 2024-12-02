# app/models/concerns/nestable_module.rb
module NestableModule
  extend ActiveSupport::Concern

  included do
    belongs_to :parent, class_name: name, optional: true
    has_many :children, class_name: name, foreign_key: 'parent_id', dependent: :destroy
  end

  def root?
    parent.nil?
  end

  def leaf?
    children.empty?
  end

  def ancestor_tree
    tree = [self]
    current = parent
    while current
      tree << current
      current = current.parent
    end
    tree
  end

  def descendant_tree
    tree = [self]
    children.each do |child|
      tree += child.descendant_tree
    end
    tree
  end
  
  def ancestor_names
    ancestor_tree.reverse.map(&:name).join(' > ')
  end

  private

  def validate_parent_child_relationship
    if parent && parent == self
      errors.add(:parent, 'cannot be the same as the current record')
    end
  end

  def has_parent?
    parent.present?
  end
end
