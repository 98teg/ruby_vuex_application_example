class ApplicationPolicy
  attr_reader :user, :target, :context

  def initialize(user, target, context)
    @user = user
    @target = target
    @context = context
  end
end
