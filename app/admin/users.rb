ActiveAdmin.register User do
  permit_params :email, :username, :password, :password_confirmation, :active
  menu label: 'Users'


  index do
    selectable_column
    id_column
    column :email
    column :username
    column :active
    column :created_at
    actions
  end

  filter :email
  filter :username
  filter :active

  member_action :change_password, method: :get do
    @user = User.find(params[:id])
  end

  member_action :update_password, method: :patch do
    @user = User.find(params[:id])
    if @user.update(permitted_params[:user])
      redirect_to collection_path, notice: "User's password has been updated"
    else
      render 'change_password'
    end
  end

  action_item :change_password, only: %i[show edit] do
    link_to('Change password', change_password_admin_user_path(user))
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      if f.object.new_record? || !f.object.password.nil?
        f.input :password
        f.input :password_confirmation
      end
      f.input :active
    end
    f.actions
  end

  show do |user|
    attributes_table do
      row :email
      row :username
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

end
