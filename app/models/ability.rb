class Ability
  include CanCan::Ability

  def initialize(user, namespace = nil)
    user ||= User.new
    case namespace
    when nil

      can :new, Place if user.persisted?
      can [:edit, :update, :destroy], Place do |place|
        user.persisted? && place.user == user
      end

      cannot [:edit, :update], Place do |place|
        !user.persisted? || place.user != user || (!Place.is_empty?(place.region, place.x, place.y) && place.state == 'draft')
      end

      can [:edit, :update, :destroy], User do |profile|
        profile == user
      end

      cannot [:new, :edit, :destroy], Project
      cannot [:new, :edit, :destroy], Region
      can :read, :all
    end
    can :manage, :all if user.admin?

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
