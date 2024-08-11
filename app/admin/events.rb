ActiveAdmin.register Event do
  permit_params :creator_id, :name, :description, :date, :location, :private, :active
  menu label: 'Events'

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :location
    column :date
    column :private
    column :creator
    column :active
    actions
  end

  filter :name
  filter :active
  filter :private
  filter :location
  
end
