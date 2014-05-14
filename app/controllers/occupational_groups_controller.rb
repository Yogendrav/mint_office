class OccupationalGroupsController < ApplicationController
  expose(:occupational_groups)
  expose(:occupational_group)

  def create
    if occupational_group.save
      redirect_to occupational_group, notice: 'Occupational group was successfully created.'
    else
      render action: :new
    end
  end

  def update
    if occupational_group.save
      redirect_to occupational_group, notice: 'Occupational group was successfully updated.' 
    else
      render action: :edit
    end
  end

  def destroy
    occupational_group.destroy
    redirect_to occupational_groups_path, notice: 'Occupational group was successfully destroyed.' 
  end
end
