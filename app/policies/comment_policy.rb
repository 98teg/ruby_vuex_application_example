class CommentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def update?
    current_user.id == target.user_id
  end

  def destroy?
    current_user.id == target.user_id
  end
end
