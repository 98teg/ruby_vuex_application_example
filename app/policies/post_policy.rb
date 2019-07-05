class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def update?
    user.id == target.user_id
  end

  def destroy?
    user.id == target.user_id
  end
end
