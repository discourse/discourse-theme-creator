import AdminAddUpload from "admin/controllers/modals/admin-add-upload";

export default AdminAddUpload.extend({
  adminCustomizeThemesShow: Ember.inject.controller("user.themes.show"),
  uploadUrl: "/user_themes/upload_asset"
});
