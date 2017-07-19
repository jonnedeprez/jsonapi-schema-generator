class UserPolicy < ApplicationPolicy

  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def show?
    return false unless scope.where(:id => record.id).exists?
    record.id == user.id || user.admin?
  end

  def update?
    return false unless scope.where(:id => record.id).exists?
    record.id == user.id || user.admin?
  end
end