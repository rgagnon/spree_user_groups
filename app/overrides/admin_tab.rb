# This modifies an existing deface override found the
# spree_auth_devise gem
Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "user_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:users, :user_groups, :url => spree.admin_users_path, :icon => 'icon-user') %>",
                     :disabled => false)
