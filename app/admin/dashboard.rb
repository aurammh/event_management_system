# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'All Users Count Check', class: 'admin-dashboard-panel' do
          div class: 'panel_contents' do
            para "Total Users: #{User.count}"
            para "Active Users: #{User.where(active: true).count}"
            para "Deactivated Users: #{User.where(active: false).count}"
          end
        end
      end
      column do
        panel 'All Events Count Check', class: 'admin-dashboard-panel' do
          div class: 'panel_contents' do
            para "Total Events: #{Event.count}"
            para "Active Events: #{Event.where(active: true).count}"
            para "Deactivated Events: #{Event.where(active: false).count}"
          end
        end
      end
    end
  end
end
