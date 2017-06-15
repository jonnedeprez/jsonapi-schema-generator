class FieldPolicy < ApplicationPolicy

  def index?
    user.admin?
  end

  def create?
    true
  end

  def destroy?
    return false unless scope.where(:id => record.id).exists?
    user.admin? || record.entity.contract.user.id == user.id
  end

  def show?
    return false unless scope.where(:id => record.id).exists?
    user.admin? || record.entity.contract.user.id == user.id
  end

  def update?
    return false unless scope.where(:id => record.id).exists?
    user.admin? || record.entity.contract.user.id == user.id
  end
end