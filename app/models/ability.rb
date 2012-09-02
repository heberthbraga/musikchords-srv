class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    if user.role? :ADMIN
      can :manage, :all
    elsif user.role? :USER
      can :read, :all
    else
    end
  end
end