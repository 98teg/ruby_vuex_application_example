class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    user.id == target.id || user.has_role?(:admin)
  end

  def destroy?
    user.id == target.id || user.has_role?(:admin)
  end
end
