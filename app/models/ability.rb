class Ability
  include CanCan::Ability

  def initialize(user, namespace = nil, project_id = nil)
    user ||= User.new

    can [:new, :create], Place do |place|
      user.persisted? && Project.find(project_id).development?
    end

    can [:edit, :update, :destroy, :crop_edit, :color_edit], Place do |place|
      place.user == user && place.project.development?
    end

    cannot [:edit, :update], Place do |place|
      !Place.is_empty?(place.region, place.x, place.y) &&
      place.state != 'published'
    end

    can :manage, User do |profile|
      profile == user
    end

    cannot :manage, Project
    can [:get_modal_resolve_size, :show_complete, :show_complete_full_size], Project

    can :read, :all

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
